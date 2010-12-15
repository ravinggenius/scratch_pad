require Rails.root + 'lib' + 'http_statuses'

class ApplicationController < ActionController::Base
  include HTTPStatuses

  protect_from_forgery
  layout 'application'

  MenuItem = Struct.new :name, :href, :children

  before_filter do
    User.current = User.find session[:current_user_id]
  end

  before_filter do
    @title = Setting[:site, :name]
  end

  before_filter do
    set_theme_ivars :frontend
  end

  before_filter do
    @main_menu_items = []
    @main_menu_items << if User.current == User.anonymous
      MenuItem.new('Sign In', new_session_path)
    else
      MenuItem.new('Profile', User.current)
    end
  end

  after_filter do
    session[:current_user_id] = User.current.id
  end

  protected

  def authorize(*allowed_groups)
    # root user is always allowed access to everything
    return true if User.current == User.root

    # root group does not have to be specified, it is always allowed
    (allowed_groups << Group.root).each { |group| return true if User.current.groups.include? group }

    false
  end

  def authorize!(*allowed_groups)
    unless authorize allowed_groups
      flash[:error] = 'You do not have permission to do that.'
      raise HTTPStatuses::Unauthorized
    end
  end

  def set_theme_ivars(frontend_backend)
    theme_name = Setting[:theme, frontend_backend]
    theme_name = params[:force_theme] if authorize && params[:force_theme]
    @selected_theme = Theme[theme_name]
    # TODO actually select a layout based on what page or node is being viewed
    @selected_layout_name = nil # nil selects the default layout
    @selected_widgets = @selected_theme.layout(@selected_layout_name).regions_hash
  end
end
