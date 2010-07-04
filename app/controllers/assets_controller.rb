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
    reply = []
    script_files = []

    script_files << 'app/vendor/modernizr/1.1/modernizr.min.js'
    script_files << 'app/vendor/jquery/1.4/jquery.min.js'

    # TODO hash all dependencies
    # TODO concatenate files in correct order

    script_files.each { |filename| reply << File.read(Rails.root + filename) }

    reply.join "\n\n\n\n\n"
  end

  def gather_styles!(format = :css)
    template_name ||= 'default' # TODO dynamically assign a template name
    cache_key = "core::styles::#{template_name}.#{format}"

    if Rails.env.to_sym == :production
      return Cache[cache_key].value unless Cache[cache_key].value.nil?
    end

    @imports = [ 'reset' ]
    @medias = {}

    enabled_extension_styles = {}

    Dir[Rails.root + 'lib/node_extensions/*'].each do |extension_path|
      extract_media_names(Dir["#{extension_path}/styles/*"]).each do |style|
        enabled_extension_styles[style] = enabled_extension_styles[style] || []
        enabled_extension_styles[style] << File.basename(extension_path)
      end
    end

    template_styles = extract_media_names(Dir[Rails.root + "lib/templates/#{template_name}/styles/*"])

    enabled_extension_styles.each do |media, extension_styles|
      load_extension_styles(media, extension_styles)
    end

    template_styles.each do |media|
      load_template_style(media, template_name)
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

    @medias.each { |media, sass| final_sass << extract_styles_for_media(media, sass) }

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

  def init_media(media_names)
    m = media_names.to_s.gsub /_/, ', '
    @medias[m] ||= ''
    m
  end

  def extract_styles_for_media(media, sass)
    <<-SASS
@media #{media}
#{sass}
    SASS
  end

  def load_extension_styles(media, extensions)
    m_key = init_media media
    extensions.each do |extension|
      @imports << "node_extensions/#{extension}/styles/#{media}"
      @medias[m_key] << <<-SASS
  .#{extension}
    @include extension_#{extension}_#{media}
      SASS
    end
  end

  def load_template_style(media, template)
    m_key = init_media media
    @imports << "templates/#{template}/styles/#{media}"
    @medias[m_key] << <<-SASS
  @include template_#{template}_#{media}
    SASS
  end
end
