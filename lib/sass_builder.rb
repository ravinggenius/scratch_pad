# http://compass-style.org/docs/index/variables/
# http://compass-users.googlegroups.com/web/_skeleton.css.sass

class SASSBuilder
  # DO NOT REORDER
  # #font_paths orders its generated paths by looping over these keys
  FONT_TYPES = {
    :woff => 'woff',
    :otf => 'opentype',
    :opentype => 'opentype',
    :ttf => 'truetype',
    :truetype => 'truetype',
    :svg => 'svg'
  }

  include Rails.application.routes.url_helpers

  def initialize(theme, addons, charset = ScratchPad::Application.config.encoding)
    @theme, @addons, @charset = theme, addons, charset
  end

  def to_css
    Sass::Engine.new(to_sass, Compass.sass_engine_options).render
  end

  def to_sass
    reply = <<-SASS
@charset '#{@charset}'
    SASS
    reply << sass_for_variables
    reply << sass_for_imports([
      'compass/css3/font-face',
      'compass/reset/utilities',
      'compass/utilities/lists'
    ])
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
        path unless path.basename.to_s.starts_with? '_'
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

    reply.force_encoding @charset
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
    (@addons + [@theme]).each do |addon|
      if File.exist? addon.styles_path + '_variables.sass'
        reply << <<-SASS
@import '#{addon.styles_path + 'variables'}'
        SASS
      end
    end
    reply
  end

  def sass_for_fonts
    reply = ''
    @theme.fonts.each do |font|
      license = if font.license
        <<-SASS
/* #{font.name} license: #{assets_static_path :theme, @theme.machine_name, :fonts, font.license}
        SASS
      end
      reply << <<-SASS
#{license || ''}@include font-face("#{font.name}", #{font_paths(font.files_by_extension)})
      SASS
    end
    reply
  end

  def font_paths(font_files)
    font_path = lambda { |type| assets_static_path :theme, @theme.machine_name, :fonts, font_files[type] }

    other_fonts = FONT_TYPES.keys.map do |type|
      "'#{font_path.call(type)}', #{FONT_TYPES[type]}" if font_files.has_key? type
    end.compact.join ', '

    # wrap non-eot fonts in SASS font-files() method. eot font is specified separately and is not passed to font-files()
    reply = other_fonts.blank? ? '' : "font-files(#{other_fonts})"

    # select(&:present?) handles the case where we only have an eot font
    reply = [reply, "'#{font_path.call(:eot)}'"].select(&:present?).join(', ') if font_files.key? :eot

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
