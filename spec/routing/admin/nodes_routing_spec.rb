require 'spec_helper'

describe Admin::NodesController do
  describe 'routing' do
    it 'recognizes and generates #index' do
      { :get => '/admin/nodes' }.should route_to(:controller => 'admin/nodes', :action => 'index')
    end

    it 'recognizes and generates #new_node_type' do
      { :get => '/admin/nodes/new_node_type' }.should route_to(:controller => 'admin/nodes', :action => 'new_node_type')
    end

    it 'recognizes and generates #new' do
      { :get => '/admin/nodes/new' }.should route_to(:controller => 'admin/nodes', :action => 'new')
    end

    it 'recognizes and generates #edit' do
      { :get => '/admin/nodes/1/edit' }.should route_to(:controller => 'admin/nodes', :action => 'edit', :id => '1')
    end

    it 'recognizes and generates #create' do
      { :post => '/admin/nodes' }.should route_to(:controller => 'admin/nodes', :action => 'create')
    end

    it 'recognizes and generates #update' do
      { :put => '/admin/nodes/1' }.should route_to(:controller => 'admin/nodes', :action => 'update', :id => '1')
    end

    it 'recognizes and generates #destroy' do
      { :delete => '/admin/nodes/1' }.should route_to(:controller => 'admin/nodes', :action => 'destroy', :id => '1')
    end
  end
end
