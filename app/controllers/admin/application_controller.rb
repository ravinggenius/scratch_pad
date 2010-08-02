class Admin::ApplicationController < ApplicationController
  layout 'admin'

  before_filter do
    @main_menu_items = [
      { :name => 'Dashboard', :href => admin_root_path },
      { :name => 'New', :href => new_admin_node_path, :children => NodeExtension.enabled.map { |extension| { :name => extension.name.titleize, :href => new_admin_node_path(:node_type => extension.name) } } },
      { :name => 'Content', :href => admin_nodes_path },
      { :name => 'Taxonomy', :href => admin_vocabularies_path },
      { :name => 'Templates', :children => [
        { :name => 'Frontend', :href => admin_templates_path(:scope => :frontend) },
        { :name => 'Backend', :href => admin_templates_path(:scope => :backend) }
      ]},
      { :name => 'Widgets' },
      { :name => 'Users' },
      { :name => 'Filters' },
      { :name => 'Settings' },
      { :name => 'Permissions' }
    ]
  end
end
