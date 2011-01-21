class AssetsController < ApplicationController
  layout nil

  def static
    addon_type = ScratchPad::Addon::Base[params[:addon_type]]
    addon = addon_type[params[:addon]]
    asset_type_path = (addon.root + params[:asset_type]).expand_path
    asset_path = (asset_type_path + params[:asset_name]).expand_path

    if File.exists?(asset_path) && addon.static_asset_types.include?(params[:asset_type]) && asset_path.to_path.starts_with?(asset_type_path.to_path)
      # https://groups.google.com/group/heroku/browse_thread/thread/e36fd2acc6ba4840
      send_file asset_path, :disposition => 'inline', :content_type => Rack::Mime.mime_type(asset_path.extname)
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
      SASSBuilder.new(theme, addons).send(format == :css ? :to_css : :to_sass)
    end

    Cache[cache_key].update_attributes! :value => body

    render :content_type => (format == :css ? 'text/css' : 'text/plain'), :text => body
  end

  private

  def addons
    ScratchPad::Addon::Widget.enabled + ScratchPad::Addon::NodeExtension.enabled
  end

  def format(default_format)
    params[:format] ? params[:format].to_sym : default_format
  end

  def theme
    @theme ||= ScratchPad::Addon::Theme[params[:theme]]
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

    script_files << addons.map { |addon| addon.scripts }
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
