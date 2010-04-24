require 'compass'

class AssetsController < ApplicationController
  layout nil

  def styles
    enabled_extension_styles = {}

    Dir[Rails.root + 'lib/node_extensions/*'].each do |extension_path|
      Dir["#{extension_path}/stylesheets/*"].map { |style| clean_filename style }.each do |style|
        enabled_extension_styles[style] = enabled_extension_styles[style] || []
        enabled_extension_styles[style] << File.basename(extension_path)
      end
    end

    template ||= 'default'

    template_styles = Dir[Rails.root + "lib/templates/#{template}/stylesheets/*"].map { |style| clean_filename style }

    sass = <<-SASS
@include 'reset'
    SASS
    sass = ''

    if enabled_extension_styles.key? :all
      sass << load_extension_styles(:all, enabled_extension_styles[:all])
      enabled_extension_styles.delete :all
    end

    if template_styles.include? :all
      sass << load_template_style(:all, template)
      template_styles.delete :all
    end

    enabled_extension_styles.each do |media, extension_styles|
      sass << load_extension_styles(media, extension_styles)
    end

    template_styles.each do |media|
      sass << load_template_style(media, template)
    end

    render :content_type => :css, :text => Sass::Engine.new(sass).render
  end

  private

  def clean_filename filename
    File.basename(filename).split('.').first.to_sym
  end

  def clean_media_names media_names
    media_names.to_s.split('_').join(', ')
  end

  def load_extension_styles media, extensions
    reply = ''

    reply << <<-SASS
@media #{clean_media_names media}
    SASS

    extensions.each do |extension|
      reply << <<-SASS
  .#{extension}
    /@include 'node_extensions/#{extension}/stylesheets/#{media}'
      SASS
    end

    reply
  end

  def load_template_style media, template
    <<-SASS
@media #{clean_media_names media}
  @include 'templates/#{template}/stylesheets/#{media}'
    SASS
  end
end
