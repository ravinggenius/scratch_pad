require 'spec_helper'

describe Admin::LayoutsController do
  describe 'routing' do
    it 'recognizes and generates #edit' do
      { :get => '/admin/themes/default/layouts/single_column/edit' }.should route_to(:controller => 'admin/layouts', :action => 'edit', :theme_id => 'default', :id => 'single_column')
    end

    it 'recognizes and generates #update' do
      { :put => '/admin/themes/default/layouts/single_column' }.should route_to(:controller => 'admin/layouts', :action => 'update', :theme_id => 'default', :id => 'single_column')
    end
  end
end
