require 'compass'

class AssetsController < ApplicationController
  layout nil

  def styles
    enabled_extension_styles = {}

    Dir[Rails.root + 'lib/node_extensions/*'].each do |extension_path|
      extract_media_names(Dir["#{extension_path}/stylesheets/*"]).each do |style|
        enabled_extension_styles[style] = enabled_extension_styles[style] || []
        enabled_extension_styles[style] << File.basename(extension_path)
      end
    end

    template ||= 'default'

    template_styles = extract_media_names(Dir[Rails.root + "lib/templates/#{template}/stylesheets/*"])

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
