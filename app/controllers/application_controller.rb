class ApplicationController < ActionController::Base
  include HTTPStatuses

  protect_from_forgery
  layout 'application'

  helper_method :current_user, :system_menu

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

  after_filter do
    session[:current_user_id] = current_user.id
  end

  def current_user
    @current_user ||= User.anonymous
  end

  protected

  # TODO add permissions for each item
  def system_menu
    reply = []

    reply << if current_user == User.anonymous
      MenuItem.new('Sign In', new_session_path)
    else
      MenuItem.new('Profile', current_user)
    end

    reply += [
      MenuItem.new('Dashboard', admin_root_path),
      MenuItem.new('Content', admin_nodes_path, [
        MenuItem.new('New', new_admin_node_path, ScratchPad::Addon::NodeExtension.enabled.sort.map { |extension|
          MenuItem.new(extension.title, new_admin_node_path(:node_type => extension.machine_name))
        })
      ]),
      MenuItem.new('Taxonomy', admin_vocabularies_path, [
        MenuItem.new('New', new_admin_vocabulary_path)
      ]),
      MenuItem.new('Filters', admin_filter_groups_path, [
        MenuItem.new('New', new_admin_filter_group_path)
      ]),
      MenuItem.new('Themes', admin_themes_path, [
        MenuItem.new('Frontend', admin_themes_path(:scope => :frontend)),
        MenuItem.new('Backend', admin_themes_path(:scope => :backend))
      ]),
      MenuItem.new('Users', admin_users_path, [
        MenuItem.new('New', new_admin_user_path)
      ]),
      MenuItem.new('Groups'),
      MenuItem.new('Permissions'),
      MenuItem.new('Settings', admin_settings_path),
      MenuItem.new('Addon Configuration', admin_addon_configurations_path, ScratchPad::Addon::Base.addon_types.map { |addon_type|
        MenuItem.new(addon_type.title.pluralize, admin_addon_configurations_path(addon_type.machine_name))
      })
    ] if authorize

    reply
  end

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
    # TODO if theme is not available, set flash.error and attempt to load default theme
    @selected_theme = ScratchPad::Addon::Theme[theme_name]
    # TODO actually select a layout based on what page or node is being viewed
    layout_name = nil # nil selects the default layout
    @selected_layout = @selected_theme.layout layout_name
  end

  # http://blog.ethanvizitei.com/2009/09/browser-caching-and-rails.html
  def clear_client_cache!
    Rails.logger.info 'Clearing client cache'
    response.headers['Cache-Control'] = 'no-cache, no-store, max-age=0, must-revalidate'
    response.headers['Pragma'] = 'no-cache'
    response.headers['Expires'] = 'Fri, 01 Jan 1990 00:00:00 GMT'
  end
end
