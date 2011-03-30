class AssetsController < ApplicationController
  layout nil

  def static
    addon = ScratchPad::Addon::Base[params[:addon_type]][params[:addon]]
    asset_type_path = (addon.public_path + params[:asset_type]).expand_path # /path/to/addon/public/images/
    asset_path = (asset_type_path + params[:asset_name]).expand_path        # /path/to/addon/public/images/organization/path/image.png

    if asset_path.file? && addon.static_asset_types.include?(params[:asset_type]) && asset_path.to_path.starts_with?(asset_type_path.to_path)
      if config.perform_caching
        # theme/default/images/organization/path/image.png
        file_name = Pathname.new(params[:addon_type]) + params[:addon] + params[:asset_type] + params[:asset_name]
        ScratchPad::StaticAssets.create(file_name, asset_path.read)
      end

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
      raise HTTPStatuses::UnprocessableEntity
    end
  end

  # TODO look into using Jammit to concatenate and minify JavaScript
  def scripts
    script_files = []

    script_files << Rails.root + 'public' + 'vendor' + 'modernizr.js'
    script_files << Rails.root + 'public' + 'vendor' + 'jquery.js'
    script_files << Rails.root + 'public' + 'vendor' + 'rails.js'

    script_files << Rails.root + 'public' + 'javascripts' + 'application.js'

    script_files << addons.map { |addon| addon.scripts }
    script_files << theme.scripts

    body = script_files.flatten.map do |script_file|
      <<-JS
/**
 * START #{script_file}
 */

#{script_file.read.strip}

/**
 * END #{script_file}
 */
      JS
    end.join("\n" * 5)

    ScratchPad::StaticAssets.create(Pathname.new(theme.machine_name) + 'scripts.js', body) if config.perform_caching

    render :js => body
  end

  # Slightly cludgy syntax is required for now.
  # @reference http://groups.google.com/group/haml/browse_thread/thread/e459fbdfa5a6d467/f9ab5f5df3fe77de
  def styles
    format = format(:css)
    body = SASSBuilder.new(theme, addons).send(format == :css ? :to_css : :to_sass)

    ScratchPad::StaticAssets.create(Pathname.new(theme.machine_name) + "styles.#{format}" , body) if config.perform_caching

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
end
