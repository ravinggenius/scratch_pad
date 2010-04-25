require 'compass'

class AssetsController < ApplicationController
  layout nil

  # Slightly cludgy syntax is required for now.
  # @reference http://groups.google.com/group/haml/browse_thread/thread/e459fbdfa5a6d467/f9ab5f5df3fe77de
  def styles
    @imports = [ 'reset' ]
    @sass = ''

    enabled_extension_styles = {}

    Dir[Rails.root + 'lib/node_extensions/*'].each do |extension_path|
      extract_media_names(Dir["#{extension_path}/stylesheets/*"]).each do |style|
        enabled_extension_styles[style] = enabled_extension_styles[style] || []
        enabled_extension_styles[style] << File.basename(extension_path)
      end
    end

    template ||= 'default'

    template_styles = extract_media_names(Dir[Rails.root + "lib/templates/#{template}/stylesheets/*"])

    if enabled_extension_styles.key? :all
      load_extension_styles(:all, enabled_extension_styles[:all])
      enabled_extension_styles.delete :all
    end

    if template_styles.include? :all
      load_template_style(:all, template)
      template_styles.delete :all
    end

    enabled_extension_styles.each do |media, extension_styles|
      load_extension_styles(media, extension_styles)
    end

    template_styles.each do |media|
      load_template_style(media, template)
    end

    final_sass = @imports.map do |inc|
      <<-SASS
@import '#{inc}'
      SASS
    end.join + @sass

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

  def clean_media_names media_names
    media_names.to_s.gsub /_/, ', '
  end

  def load_extension_styles media, extensions
    reply = ''

    @sass << <<-SASS
@media #{clean_media_names media}
    SASS

    extensions.each do |extension|
      @imports << "node_extensions/#{extension}/stylesheets/#{media}"
      @sass << <<-SASS
  .#{extension}
    @include extension_#{extension}_#{media}
      SASS
    end

    reply
  end

  def load_template_style media, template
    @imports << "templates/#{template}/stylesheets/#{media}"
    @sass << <<-SASS
@media #{clean_media_names media}
  @include template_#{template}_#{media}
    SASS
  end
end
