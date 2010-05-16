require 'compass'

class AssetsController < ApplicationController
  layout nil

  # Slightly cludgy syntax is required for now.
  # @reference http://groups.google.com/group/haml/browse_thread/thread/e459fbdfa5a6d467/f9ab5f5df3fe77de
  def styles
    body = ensure_styles_exist!
    render :content_type => (params[:format].to_sym == :sass ? :text : :css), :text => body
  end

  private

  def ensure_styles_exist!
    template_name ||= 'default' # TODO dynamically assign a template name
    cache_key = "core::styles::#{template_name}.#{params[:format]}"

    cache = Cache.first :key => cache_key

    if Rails.env.to_sym == :production
      return cache.value unless cache.nil?
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

    @medias.each { |media, sass| final_sass << extract_styles_for_media(media, sass) }

    body = params[:format].to_sym == :sass ? final_sass : Sass::Engine.new(final_sass, Compass.sass_engine_options).render

    cache = Cache.new if cache.nil?
    cache.update_attributes!(:key => cache_key, :value => body)

    body
  end

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
      @imports << "node_extensions/#{extension}/styles/#{media}"
      @medias[m_key] << <<-SASS
  .#{extension}
    @include extension_#{extension}_#{media}
      SASS
    end
  end

  def load_template_style media, template
    m_key = init_media media
    @imports << "templates/#{template}/styles/#{media}"
    @medias[m_key] << <<-SASS
  @include template_#{template}_#{media}
    SASS
  end
end
