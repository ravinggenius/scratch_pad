class Admin::ApplicationController < ApplicationController
  layout 'admin'

  before_filter do
    @main_menu_items = [
      { :name => 'Dashboard', :href => admin_root_path },
      { :name => 'Content', :href => admin_nodes_path, :children => [
        { :name => 'New', :href => new_admin_node_path, :children => NodeExtension.enabled.map { |extension| { :name => extension.name.titleize, :href => new_admin_node_path(:node_type => extension.name) } } }
      ]},
      { :name => 'Taxonomy', :href => admin_vocabularies_path, :children => [
        { :name => 'New', :href => new_admin_vocabulary_path }
      ]},
      { :name => 'Widgets' },
      { :name => 'Templates', :children => [
        { :name => 'Frontend', :href => admin_templates_path(:scope => :frontend) },
        { :name => 'Backend', :href => admin_templates_path(:scope => :backend) }
      ]},
      { :name => 'Filters', :href=> admin_filters_path },
      { :name => 'Users', :href => admin_users_path, :children => [
        { :name => 'New', :href => new_admin_user_path }
      ]},
      { :name => 'Groups' },
      { :name => 'Permissions' },
      { :name => 'Settings' }
    ]
  end
end
