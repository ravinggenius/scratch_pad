class Admin::ApplicationController < ApplicationController
  layout 'admin'

  before_filter do
    authorize!
  end

  before_filter do
    @main_menu_items = [
      { :name => 'Dashboard', :href => admin_root_path },
      { :name => 'Content', :href => admin_nodes_path, :children => [
        { :name => 'New', :href => new_admin_node_path, :children => NodeExtension.enabled.map { |extension| { :name => extension.name, :href => new_admin_node_path(:node_type => extension.machine_name) } } }
      ]},
      { :name => 'Taxonomy', :href => admin_vocabularies_path, :children => [
        { :name => 'New', :href => new_admin_vocabulary_path }
      ]},
      { :name => 'Widgets' },
      { :name => 'Themes', :children => [
        { :name => 'Frontend', :href => admin_themes_path(:scope => :frontend) },
        { :name => 'Backend', :href => admin_themes_path(:scope => :backend) }
      ]},
      { :name => 'Filters', :href=> admin_filter_groups_path, :children => [
        { :name => 'New', :href => new_admin_filter_group_path }
      ]},
      { :name => 'Users', :href => admin_users_path, :children => [
        { :name => 'New', :href => new_admin_user_path }
      ]},
      { :name => 'Groups' },
      { :name => 'Permissions' },
      { :name => 'Settings', :href => admin_settings_path },
      { :name => 'Addons', :href => admin_addons_path }
    ]
  end
end
