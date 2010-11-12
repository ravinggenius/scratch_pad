require Rails.root + 'lib' + 'http_statuses'

class ApplicationController < ActionController::Base
  include HTTPStatuses

  protect_from_forgery
  layout 'application'
  append_view_path NodeExtension.path

  before_filter do
    User.current = User.find session[:current_user_id]
  end

  before_filter do
    @title = Setting[:sp, :site, :name]
    @main_menu_items = []
    @main_menu_items << if User.current == User.anonymous
      { :name => 'Sign In', :href => new_session_path }
    else
      { :name => 'Profile', :href => node_path(User.current) }
    end
  end

  before_filter do
    @widgets = {}
    @widgets[:head] = [ Widget[:google_analytics] ]
    @widgets[:branding] = [ Widget[:branding] ]
    @widgets[:flash] = [ Widget[:flash] ]
    @widgets[:credits] = [ Widget[:copyright], Widget[:unobtrusive] ]
    @widgets[:tail] = [ Widget[:woopra] ]
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
end
