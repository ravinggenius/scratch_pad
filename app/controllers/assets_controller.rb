class AssetsController < ApplicationController
  layout nil

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

    if Rails.env.to_sym == :production
      return Cache[cache_key].value unless Cache[cache_key].expired?
    end

    body = SASSBuilder.new(theme, Widget.enabled + NodeExtension.enabled).send(format == :sass ? :to_sass : :to_css)

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

    script_files << (NodeExtension.all + Widget.all).map { |addon| addon.scripts }
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
