# http://compass-style.org/docs/index/variables/
# http://compass-users.googlegroups.com/web/_skeleton.css.sass

class SASSBuilder
  FONT_TYPES = {
    :otf => 'opentype',
    :svg => 'svg',
    :ttf => 'truetype',
    :truetype => 'truetype',
    :woff => 'woff'
  }

  include Rails.application.routes.url_helpers

  attr_accessor :fonts, :imports, :variables
  attr_reader :charset, :theme

  def initialize(theme, charset = 'utf-8')
    @theme, @charset = theme, charset
    @fonts = theme.fonts
  end

  def to_css
    Sass::Engine.new(to_sass, Compass.sass_engine_options).render
  end

  def to_sass
    @imports = [ 'compass/reset/utilities', 'compass/css3/font-face' ]
    @medias = {}

    include_enabled_styles_for Widget
    include_enabled_styles_for NodeExtension

    theme_styles = extract_media_names theme.styles
    theme_styles.each do |media|
      @medias[media] ||= ''
      @imports << "themes/#{theme.machine_name}/styles/#{media}"
      @medias[media] << <<-SASS
  @include theme_#{theme.machine_name}_#{media}
      SASS
    end

    final_sass = <<-SASS
@charset 'utf-8'
    SASS

    scope = [:theme, :support].join Setting::SCOPE_GLUE
    Setting.all_in_scope(scope).each do |setting|
      vendor = setting.scope.gsub "#{scope}#{Setting::SCOPE_GLUE}", ''
      final_sass << <<-SASS
$experimental-support-for-#{vendor}: #{setting.value.blank? ? 'false' : setting.value}
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

    final_sass
  end

  protected

  def extract_media_names(paths)
    paths.map do |path|
      reply = path.basename.to_s.split('.').first
      reply.to_sym unless reply.starts_with? '_'
    end.compact
  end

  def extract_styles_for_media(media, sass)
    <<-SASS
@media #{media.to_s.gsub /_/, ', '}
#{sass}
    SASS
  end

  def include_enabled_styles_for(addon_type)
    addon_name = addon_type.title.underscore

    enabled_styles = {}

    addon_type.all.each do |addon|
      extract_media_names(addon.styles).each do |style|
        enabled_styles[style] = enabled_styles[style] || []
        enabled_styles[style] << addon.root.basename
      end
    end

    enabled_styles.each do |media, addon_styles|
      @medias[media] ||= ''
      addon_styles.each do |addon|
        @imports << "#{addon_name.pluralize}/#{addon}/styles/#{media}"
        @medias[media] << <<-SASS
  .#{addon.to_s.dasherize}
    @include #{addon_name}_#{addon}_#{media}
        SASS
      end
    end
  end
end
