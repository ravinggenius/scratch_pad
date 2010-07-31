class Admin::ApplicationController < ApplicationController
  layout 'admin'

  before_filter do
    @active_node_extensions = available_node_extensions
  end

  before_filter do
    @main_menu_items = [
      { :name => 'Dashboard', :href => admin_root_path },
      { :name => 'New', :href => new_admin_node_path, :children => @active_node_extensions.map { |extension| { :name => extension.titleize, :href => new_admin_node_path(:node_type => extension) } }
      },
      { :name => 'Content', :href => admin_nodes_path },
      { :name => 'Taxonomy', :href => admin_taxonomies_path },
      { :name => 'Templates', :children => [
        { :name => 'Frontend' },
        { :name => 'Backend' }
      ]},
      { :name => 'Settings' }
    ]
  end

  private

  def available_node_extensions
    @available_node_extensions ||= (Dir.entries Rails.root + 'lib' + 'node_extensions').delete_if { |entry| entry =~ /^\./ }
  end
end
