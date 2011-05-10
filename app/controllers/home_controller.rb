class HomeController < ApplicationController
  # TODO convert this to a lambda and move to routes, perhaps
  def index
    home_page = Setting[:site, :home_page]

    if home_page.present?
      setting = home_page.split '#'

      case setting.count
      when 1
        # show a specific node
        params[:path] = setting.first
        s_controller, s_action = :nodes, :show_human
      when 2, 3
        # show an arbitrary controller#action pair, with optional id
        s_controller, s_action, params[:id] = setting
        params.delete :id unless params[:id]
      else
        # this shouldn't happen...
        # fall back to just listing nodes
        s_controller, s_action = :nodes, :index
      end

      reply = "#{s_controller}_controller".classify.constantize.action(s_action).call(env)
      status, response_headers, response_body = reply

      # FIXME this is gross, but seems to work
      # this is needed because status is 304 every other request
      if (200..299).include? status
        render :text => response_body.body
      else
        head status
      end
    else
      render :file => @selected_theme.find_view(:home)
    end
  end
end
