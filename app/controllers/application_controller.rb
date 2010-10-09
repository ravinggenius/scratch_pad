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
    @title = Setting['core.site.name'].user_value
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
