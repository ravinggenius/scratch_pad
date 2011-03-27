require 'spec_helper'

describe Admin::ThemesController do
  describe 'routing' do
    it 'recognizes and generates #index' do
      { :get => '/admin/themes' }.should route_to(:controller => 'admin/themes', :action => 'index')
    end

    it 'recognizes and generates #update' do
      { :post => '/admin/themes' }.should route_to(:controller => 'admin/themes', :action => 'update')
    end
  end
end
