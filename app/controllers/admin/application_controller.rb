class Admin::ApplicationController < ApplicationController
  before_filter do
    authorize!
  end

  # TODO remove duplication from ApplicationController
  before_filter do
    @selected_theme = pick_theme Setting[:theme, :backend]
    # TODO actually select a layout based on what page or node is being viewed
    @selected_layout = nil # nil selects the default layout
    @selected_widgets = Theme[@selected_theme].layout(@selected_layout).regions_hash
  end

  before_filter do
    @main_menu_items = [
      MenuItem.new('Dashboard', admin_root_path),
      MenuItem.new('Content', admin_nodes_path, [
        MenuItem.new('New', new_admin_node_path, NodeExtension.enabled.map { |extension|
          MenuItem.new(extension.name, new_admin_node_path(:node_type => extension.machine_name))
        })
      ]),
      MenuItem.new('Taxonomy', admin_vocabularies_path, [
        MenuItem.new('New', new_admin_vocabulary_path)
      ]),
      MenuItem.new('Widgets', admin_widgets_path),
      MenuItem.new('Themes', admin_themes_path, [
        MenuItem.new('Frontend', admin_themes_path(:scope => :frontend)),
        MenuItem.new('Backend', admin_themes_path(:scope => :backend))
      ]),
      MenuItem.new('Filters', admin_filter_groups_path, [
        MenuItem.new('New', new_admin_filter_group_path)
      ]),
      MenuItem.new('Users', admin_users_path, [
        MenuItem.new('New', new_admin_user_path)
      ]),
      MenuItem.new('Groups'),
      MenuItem.new('Permissions'),
      MenuItem.new('Settings', admin_settings_path),
      MenuItem.new('Addons', admin_addons_path, [
        MenuItem.new('Filters', admin_addons_path(:addon => :filter)),
        MenuItem.new('NodeExtensions', admin_addons_path(:addon => :node_extension)),
        MenuItem.new('Themes', admin_addons_path(:addon => :theme)),
        MenuItem.new('Widgets', admin_addons_path(:addon => :widget))
      ])
    ]
  end
end
