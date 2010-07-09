require 'compass'

class AssetsController < ApplicationController
  layout nil

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
    cache_key = "core::styles::#{template_name}.js"

    if Rails.env.to_sym == :production
      return Cache[cache_key].value unless Cache[cache_key].value.nil?
    end

    script_files = []

    script_files << 'app/vendor/modernizr/1.1/modernizr.min.js'
    script_files << 'app/vendor/jquery/1.4/jquery.min.js'

    script_files << Dir[Rails.root + 'lib/node_extensions/**/views/scripts/*.js']
    script_files << Dir[Rails.root + "lib/templates/#{template_name}/scripts/*.js"]

    reply = script_files.flatten.map { |filename| File.read(Rails.root + filename) }.join "\n\n\n\n\n"

    Cache[cache_key].update_attributes! :value => reply

    reply
  end

  def gather_styles!(format = :css)
    cache_key = "core::styles::#{template_name}.#{format}"

    if Rails.env.to_sym == :production
      return Cache[cache_key].value unless Cache[cache_key].value.nil?
    end

    @imports = [ 'reset' ]
    @medias = {}

    enabled_extension_styles = {}
    Dir[Rails.root + 'lib/node_extensions/*'].each do |extension_path|
      extract_media_names(Dir["#{extension_path}/views/styles/*"]).each do |style|
        enabled_extension_styles[style] = enabled_extension_styles[style] || []
        enabled_extension_styles[style] << File.basename(extension_path)
      end
    end
    enabled_extension_styles.each do |media, extension_styles|
      @medias[media] ||= ''
      extension_styles.each do |extension|
        @imports << "node_extensions/#{extension}/views/styles/#{media}"
        @medias[media] << <<-SASS
  .#{extension}
    @include extension_#{extension}_#{media}
        SASS
      end
    end

    template_styles = extract_media_names(Dir[Rails.root + "lib/templates/#{template_name}/styles/*"])
    template_styles.each do |media|
      @medias[media] ||= ''
      @imports << "templates/#{template_name}/styles/#{media}"
      @medias[media] << <<-SASS
  @include template_#{template_name}_#{media}
      SASS
    end

    final_sass = <<-SASS
@charset 'utf-8'
    SASS

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

  def template_name
    # TODO dynamically assign a template name (template should be selectable, at least by root)
    @template_name ||= 'default'
  end
end
