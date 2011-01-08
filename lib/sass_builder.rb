# http://compass-style.org/docs/index/variables/
# http://compass-users.googlegroups.com/web/_skeleton.css.sass

class SASSBuilder
  FONT_TYPES = {
    :woff => 'woff',
    :otf => 'opentype',
    :opentype => 'opentype',
    :ttf => 'truetype',
    :truetype => 'truetype',
    :svg => 'svg'
  }

  include Rails.application.routes.url_helpers

  attr_reader :charset, :theme

  def initialize(theme, addons, charset = 'utf-8')
    @theme, @addons, @charset = theme, addons, charset
    @fonts = theme.fonts
  end

  def to_css
    Sass::Engine.new(to_sass, Compass.sass_engine_options).render
  end

  def to_sass
    reply = <<-SASS
@charset 'utf-8'
    SASS
    reply << sass_for_variables
    reply << sass_for_imports([ 'compass/reset/utilities', 'compass/css3/font-face' ])
    reply << sass_for_fonts

    medias = {
      :all => <<-SASS
  @include global-reset
  @include reset-html5
      SASS
    }

    # for each addon, gather list of stylesheets and convert to sass import statements
    (@addons + [@theme]).each do |addon|
      imports = addon.styles.map do |path|
        media = path.basename.to_s.split('.').first
        addon.root(true) + 'styles' + media unless media.starts_with? '_'
      end.compact
      reply << sass_for_imports(imports)
    end

    # build scoped include statements for addons, grouped by media
    @addons.each do |addon|
      addon.stylesheets.each do |sheet|
        media_key = extract_media_key sheet
        medias[media_key] ||= ''
        medias[media_key] << <<-SASS
  .#{addon.machine_name.dasherize}
    @include #{addon.machine_name}_#{media_key}
        SASS
      end
    end

    # build include statements for theme, grouped by media
    @theme.stylesheets.each do |sheet|
      media_key = extract_media_key sheet
      medias[media_key] ||= ''
      medias[media_key] << <<-SASS
  @include #{@theme.machine_name}_#{media_key}
      SASS
    end

    # output all media styles first
    reply << sass_for_media(:all, medias.delete(:all)) if medias.key? :all

    # sort media keys so styles targeting more media devices are output first
    media_keys = medias.keys.sort do |a, b|
      a, b = a.to_s, b.to_s
      r = b.count('_') <=> a.count('_')
      r = a <=> b if r == 0
      r
    end
    media_keys.each { |key| reply << sass_for_media(key, medias[key]) }

    reply
  end

  protected

  def sass_for_variables
    reply = ''
    scope = [:theme, :support].join Setting::SCOPE_GLUE
    Setting.all_in_scope(scope).each do |setting|
      vendor = setting.scope.gsub "#{scope}#{Setting::SCOPE_GLUE}", ''
      reply << <<-SASS
$experimental-support-for-#{vendor}: #{setting.value.blank? ? 'false' : setting.value}
      SASS
    end
    reply
  end

  def sass_for_fonts
    reply = ''
    @theme.fonts.each do |font_name, font_files|
      reply << <<-SASS
@include font-face("#{font_name}", #{font_paths(font_files)})
      SASS
    end
    reply
  end

  def font_paths(fonts)
    reply = ''
    eot = fonts.delete :eot
    others = FONT_TYPES.keys.map do |type|
      "\"#{assets_font_path(theme.machine_name, fonts[type])}\", #{FONT_TYPES[type]}" if fonts.has_key? type
    end.compact.join ', '
    reply = "font-files(#{others})" unless others.blank?
    reply = [reply, "\"#{assets_font_path(theme.machine_name, eot)}\", eot"].join ', ' unless eot.nil?
    reply
  end

  def sass_for_imports(paths)
    reply = ''
    paths.each do |path|
      reply << <<-SASS
@import '#{path}'
      SASS
    end
    reply
  end

  def sass_for_media(media, sass)
    <<-SASS
@media #{media.to_s.gsub /_/, ', '}
#{sass}
    SASS
  end

  def extract_media_key(sheet)
    sheet.basename.to_s.split('.').first.to_sym
  end
end
