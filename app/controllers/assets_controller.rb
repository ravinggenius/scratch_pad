class AssetsController < ApplicationController
  layout nil

  def routes
    render :text => begin
      if params[:named_route]
        params.delete :controller
        params.delete :action
        named_route = params.delete(:named_route).downcase.gsub(/[^a-z_]/, '')
        send "#{named_route}_url", params
      else
        params[:controller] = params.delete :c if params[:c]
        params[:action] = params.delete :a if params[:a]
        url_for params
      end
    rescue
      'invalid parameters'
    end
  end

  def scripts
    render :js => gather_scripts!
  end

  # Slightly cludgy syntax is required for now.
  # @reference http://groups.google.com/group/haml/browse_thread/thread/e459fbdfa5a6d467/f9ab5f5df3fe77de
  def styles
    format = format(:css)
    render :content_type => (format == :css ? 'text/css' : 'text/plain'), :text => gather_styles!(format)
  end

  private

  def format(default_format)
    begin
      params[:format].to_sym
    rescue
      default_format
    end
  end

  def gather_scripts!
    cache_key = "core::styles::#{theme.name}.js"

    if Rails.env.to_sym == :production
      return Cache[cache_key].value unless Cache[cache_key].expired?
    end

    script_files = []

    script_files << Rails.root + 'app/vendor/modernizr.js'
    script_files << Rails.root + 'app/vendor/jquery.js'
    script_files << Rails.root + 'app/vendor/rails.js'

    script_files << Rails.root + 'public/javascripts/application.js'

    script_files << (NodeExtension.all + Widget.all).map { |addon| addon.glob 'scripts/*.js' }
    script_files << theme.glob('scripts/*.js')

    reply = script_files.flatten.map do |filename|
      <<-JS
/**
 * START #{filename}
 */

#{File.read(filename).strip}

/**
 * END #{filename}
 */
      JS
    end.join("\n" * 5)

    Cache[cache_key].update_attributes! :value => reply

    reply
  end

  def gather_styles!(format = :css)
    cache_key = "core::styles::#{theme.name}.#{format}"

    if Rails.env.to_sym == :production
      return Cache[cache_key].value unless Cache[cache_key].expired?
    end

    @imports = [ 'reset' ]
    @medias = {}

    # TODO combine the next two blocks
    enabled_widget_styles = {}
    Widget.all.each do |w|
      extract_media_names(w.glob 'styles/*').each do |style|
        enabled_widget_styles[style] = enabled_widget_styles[style] || []
        enabled_widget_styles[style] << File.basename(w.path)
      end
    end
    enabled_widget_styles.each do |media, widget_styles|
      @medias[media] ||= ''
      widget_styles.each do |widget|
        @imports << "widgets/#{widget}/styles/#{media}"
        @medias[media] << <<-SASS
  .#{widget}
    @include widget_#{widget}_#{media}
        SASS
      end
    end

    enabled_extension_styles = {}
    NodeExtension.all.each do |ne|
      extract_media_names(ne.glob 'styles/*').each do |style|
        enabled_extension_styles[style] = enabled_extension_styles[style] || []
        enabled_extension_styles[style] << File.basename(ne.path)
      end
    end
    enabled_extension_styles.each do |media, extension_styles|
      @medias[media] ||= ''
      extension_styles.each do |extension|
        @imports << "node_extensions/#{extension}/styles/#{media}"
        @medias[media] << <<-SASS
  .#{extension}
    @include extension_#{extension}_#{media}
        SASS
      end
    end

    theme_styles = extract_media_names theme.glob('styles/*')
    theme_styles.each do |media|
      @medias[media] ||= ''
      @imports << "themes/#{theme.name}/styles/#{media}"
      @medias[media] << <<-SASS
  @include theme_#{theme.name}_#{media}
      SASS
    end

    # http://compass-style.org/docs/index/variables/
    # http://compass-users.googlegroups.com/web/_skeleton.css.sass
    final_sass = <<-SASS
@charset 'utf-8'
    SASS

    scope = 'addon.theme.support'
    Setting.all(:scope => /#{scope}/).each do |setting|
      browser = setting.scope.gsub "#{scope}.", ''
      value = Setting["#{scope}.#{browser}"]
      final_sass << <<-SASS
$experimental-support-for-#{browser}: #{value.blank? ? 'false' : value}
      SASS
    end

    @imports.each do |inc|
      final_sass << <<-SASS
@import '#{inc}'
      SASS
    end

    if @medias.key? :all
      final_sass << extract_styles_for_media(:all, @medias[:all])
      @medias.delete :all
    end

    media_keys = @medias.keys.sort do |a, b|
      a, b = a.to_s, b.to_s
      reply = b.count('_') <=> a.count('_')
      reply = a <=> b if reply == 0
      reply
    end
    media_keys.each { |key| final_sass << extract_styles_for_media(key, @medias[key]) }

    body = format == :sass ? final_sass : Sass::Engine.new(final_sass, Compass.sass_engine_options).render

    Cache[cache_key].update_attributes! :value => body

    body
  end

  def extract_media_names(paths)
    paths.map do |path|
      reply = File.basename(path).split('.').first
      reply.to_sym unless reply.starts_with? '_'
    end.compact
  end

  def extract_styles_for_media(media, sass)
    <<-SASS
@media #{media.to_s.gsub /_/, ', '}
#{sass}
    SASS
  end

  def theme
    @theme ||= Theme.new params[:theme]
  end
end
