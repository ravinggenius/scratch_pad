class ApplicationController < ActionController::Base
  protect_from_forgery
  layout 'application'
  append_view_path NodeExtension.path

  # TODO move these to settings in the database
  before_filter do
    # TODO load default settings
    @title = 'ScratchPad'
    @site_name = 'ScratchPad'
    @site_tagline = ''
    # TODO load user settings
  end

  after_filter do
    session[:current_user_id] = User.current.id if User.current
  end

  protected

  # Usage:
  # setting('core.templates.active')       #=> 'default'
  # setting('core.templates.active.admin') #=> 'default_admin'
  # setting('core.site.name')              #=> 'ScratchPad'
  # setting('core.site.tagline')           #=> '...'
  # setting('template.<name>.<some_setting>') #=> 3
  # setting('node_extension.<name>.<...>') #=> 'alternate'
  def setting(scope)
    Setting[scope].value_for(User.current).value
  end
end
