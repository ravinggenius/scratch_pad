require 'compass'

class AssetsController < ApplicationController
  layout nil

  # Slightly cludgy syntax is required for now.
  # @reference http://groups.google.com/group/haml/browse_thread/thread/e459fbdfa5a6d467/f9ab5f5df3fe77de
  def styles
    @imports = [ 'reset' ]
    @medias = {}

    enabled_extension_styles = {}

    Dir[Rails.root + 'lib/node_extensions/*'].each do |extension_path|
      extract_media_names(Dir["#{extension_path}/stylesheets/*"]).each do |style|
        enabled_extension_styles[style] = enabled_extension_styles[style] || []
        enabled_extension_styles[style] << File.basename(extension_path)
      end
    end

    template_name ||= 'default'
    template_styles = extract_media_names(Dir[Rails.root + "lib/templates/#{template_name}/stylesheets/*"])

    enabled_extension_styles.each do |media, extension_styles|
      load_extension_styles(media, extension_styles)
    end

    template_styles.each do |media|
      load_template_style(media, template_name)
    end

    final_sass = <<-SASS
@charset "utf-8"
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

    @medias.each do |media, sass|
      final_sass << extract_styles_for_media(media, sass)
    end

    content_type, body = case params[:format].to_sym
      when :sass then [ :text, final_sass ]
      else            [ :css,  Sass::Engine.new(final_sass, Compass.sass_engine_options).render ]
    end

    render :content_type => content_type, :text => body
  end

  private

  def extract_media_names paths
    paths.map do |path|
      reply = File.basename(path).split('.').first
      reply.to_sym unless reply.starts_with? '_'
    end.compact
  end

  def init_media media_names
    m = media_names.to_s.gsub /_/, ', '
    @medias[m] ||= ''
    m
  end

  def extract_styles_for_media media, sass
    <<-SASS
@media #{media}
#{sass}
    SASS
  end

  def load_extension_styles media, extensions
    m_key = init_media media
    extensions.each do |extension|
      @imports << "node_extensions/#{extension}/stylesheets/#{media}"
      @medias[m_key] << <<-SASS
  .#{extension}
    @include extension_#{extension}_#{media}
      SASS
    end
  end

  def load_template_style media, template
    m_key = init_media media
    @imports << "templates/#{template}/stylesheets/#{media}"
    @medias[m_key] << <<-SASS
  @include template_#{template}_#{media}
    SASS
  end
end
