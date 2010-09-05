class ApplicationController < ActionController::Base
  protect_from_forgery
  layout 'application'
  append_view_path NodeExtension.path

  before_filter do
    @title = Setting['core.site.name'].value_for(User.current).value
  end

  after_filter do
    session[:current_user_id] = User.current.id
  end
end
