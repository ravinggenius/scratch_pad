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
    Dir[Rails.root + user_class_files].each { |model| require model }
    user_klass = user_class.constantize
    user_klass.anonymous = User.first :user_name => 'anon'
    user_klass.current = User.find(session[:current_user_id]) || User.anonymous
  end

  after_filter do
    session[:current_user_id] = User.current.id if User.current
  end

  private

  def user_class
    'User'
  end

  def user_class_files
    'lib/user/models/*.rb'
  end
end
