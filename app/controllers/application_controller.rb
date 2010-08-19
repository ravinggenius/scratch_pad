class ApplicationController < ActionController::Base
  protect_from_forgery
  layout 'application'
  append_view_path NodeExtension.path

  # TODO move these to settings in the database
  before_filter do
    @title = 'ScratchPad'
    @site_name = 'ScratchPad'
    @site_tagline = ''
  end

  after_filter do
    session[:current_user_id] = User.current.id if User.current
  end
end
