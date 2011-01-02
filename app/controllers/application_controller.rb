require Rails.root + 'lib' + 'http_statuses'

class ApplicationController < ActionController::Base
  include HTTPStatuses

  protect_from_forgery
  layout 'application'

  helper_method :current_user

  MenuItem = Struct.new :name, :href, :children

  before_filter do
    self.current_user = User.find session[:current_user_id]
  end

  before_filter do
    @title = Setting[:site, :name]
  end

  before_filter do
    set_theme_ivars :frontend
  end

  # TODO add permissions for each item
  before_filter do
    @system_menu = []
    @system_menu << if current_user == User.anonymous
      MenuItem.new('Sign In', new_session_path)
    else
      MenuItem.new('Profile', current_user)
    end
  end

  after_filter do
    session[:current_user_id] = current_user.id
  end

  def current_user
    @current_user ||= User.anonymous
  end

  protected

  def current_user=(user)
    @current_user = user
  end

  def authorize(*allowed_groups)
    # root user is always allowed access to everything
    return true if current_user == User.root

    # root group does not have to be specified, it is always allowed
    (allowed_groups << Group.root).each { |group| return true if current_user.groups.include? group }

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
    layout_name = nil # nil selects the default layout
    @selected_layout = @selected_theme.layout layout_name
  end
end
