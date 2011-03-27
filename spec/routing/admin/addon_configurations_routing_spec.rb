require 'spec_helper'

describe Admin::AddonConfigurationsController do
  describe 'routing' do
    it 'recognizes and generates #index' do
      { :get => '/admin/addon_configurations' }.should route_to(:controller => 'admin/addon_configurations', :action => 'index')
      { :get => '/admin/addon_configurations/theme' }.should route_to(:controller => 'admin/addon_configurations', :action => 'index', :addon_type => 'theme')
    end

    it 'recognizes and generates #update' do
      { :post => '/admin/addon_configurations' }.should route_to(:controller => 'admin/addon_configurations', :action => 'update')
      { :post => '/admin/addon_configurations/theme' }.should route_to(:controller => 'admin/addon_configurations', :action => 'update', :addon_type => 'theme')
    end
  end
end
