class AssetsController < ApplicationController
  layout nil

  def image
    addon = AddonBase[params[:addon]]
    image_path = (addon.images_path + params[:image_name]).expand_path

    if File.exists?(image_path) && image_path.to_path.starts_with?(addon.images_path.to_path)
      send_file image_path, :disposition => 'inline', :content_type => Rack::Mime.mime_type(image_path.extname)
    else
      raise HTTPStatuses::NotFound
    end
  end

  def font
    theme = Theme[params[:theme]]
    font_path = (theme.fonts_path + params[:font_name]).expand_path

    if File.exists?(font_path) && font_path.to_path.starts_with?(theme.fonts_path.to_path)
      send_file font_path, :content_type => Rack::Mime.mime_type(font_path.extname)
    else
      raise HTTPStatuses::NotFound
    end
  end

  def routes
    render :text => begin
      if params[:named_route]
        params.delete :controller
        params.delete :action
        named_route = params.delete(:named_route).downcase.gsub(/[^a-z_]/, '')
        send "#{named_route}_url", params
      else
        params[:controller] = params.delete :c if params[:c]
        params[:action] = params.delete :a if params[:a]
        url_for params
      end
    rescue
      'invalid parameters'
    end
  end

  def scripts
    render :js => gather_scripts!
  end

  # Slightly cludgy syntax is required for now.
  # @reference http://groups.google.com/group/haml/browse_thread/thread/e459fbdfa5a6d467/f9ab5f5df3fe77de
  def styles
    format = format(:css)
    cache_key = [:core, :styles, theme.machine_name, format]

    body = if (Rails.env.to_sym == :production) && !Cache[cache_key].expired?
      Rails.logger.info "CACHE[#{cache_key.join '.'}]"
      Cache[cache_key].value
    else
      Rails.logger.info "Rebuilding CACHE[#{cache_key.join '.'}]"
      SASSBuilder.new(theme, Widget.enabled + NodeExtension.enabled).send(format == :css ? :to_css : :to_sass)
    end

    Cache[cache_key].update_attributes! :value => body

    render :content_type => (format == :css ? 'text/css' : 'text/plain'), :text => body
  end

  private

  def format(default_format)
    params[:format] ? params[:format].to_sym : default_format
  end

  def theme
    @theme ||= Theme[params[:theme]]
  end

  def gather_scripts!
    cache_key = [:core, :styles, theme.machine_name, :js]

    if Rails.env.to_sym == :production
      return Cache[cache_key].value unless Cache[cache_key].expired?
    end

    script_files = []

    script_files << Rails.root + 'public' + 'vendor' + 'modernizr.js'
    script_files << Rails.root + 'public' + 'vendor' + 'jquery.js'
    script_files << Rails.root + 'public' + 'vendor' + 'rails.js'

    script_files << Rails.root + 'public' + 'javascripts' + 'application.js'

    script_files << (NodeExtension.enabled + Widget.enabled).map { |addon| addon.scripts }
    script_files << theme.scripts

    reply = script_files.flatten.map do |filename|
      <<-JS
/**
 * START #{filename}
 */

#{File.read(filename).strip}

/**
 * END #{filename}
 */
      JS
    end.join("\n" * 5)

    Cache[cache_key].update_attributes! :value => reply

    reply
  end
end
