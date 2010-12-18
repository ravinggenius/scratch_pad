class Admin::ApplicationController < ApplicationController
  before_filter do
    authorize!
  end

  before_filter do
    set_theme_ivars :backend
  end

  before_filter do
    @system_menu = [
      MenuItem.new('Dashboard', admin_root_path),
      MenuItem.new('Content', admin_nodes_path, [
        MenuItem.new('New', new_admin_node_path, NodeExtension.enabled.sort.map { |extension|
          MenuItem.new(extension.name, new_admin_node_path(:node_type => extension.machine_name))
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
      MenuItem.new('Addons', admin_addons_path, AddonBase.addon_types.map { |addon_type|
        MenuItem.new(addon_type.name.pluralize, admin_addons_path(:addon_type => addon_type.machine_name))
      })
    ]
  end
end
