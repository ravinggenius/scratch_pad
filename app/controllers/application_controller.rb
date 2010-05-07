class ApplicationController < ActionController::Base
  protect_from_forgery
  layout 'application'
  append_view_path 'lib/node_extensions'

  before_filter do
    @title = 'ScratchPad'
    @site_name = 'ScratchPad'
    @site_tagline = ''
  end

  before_filter do
    User.anonymous = User.first :user_name => 'anon'
    User.current = User.find(session[:current_user_id]) || User.anonymous
  end

  after_filter do
    session[:current_user_id] = User.current.id if User.current
  end
end
