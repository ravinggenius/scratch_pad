require 'spec_helper'

describe Admin::DashboardController do
  describe 'routing' do
    it 'recognizes and generates #index' do
      { :get => '/admin' }.should route_to(:controller => 'admin/dashboard', :action => 'index')
    end
  end
end
