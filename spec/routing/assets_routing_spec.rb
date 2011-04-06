require 'spec_helper'

describe AssetsController do
  describe 'routing' do
    it 'recognizes and generates #scripts' do
      { :get => '/assets/theme/default/scripts.js' }.should route_to(:controller => 'assets', :action => 'scripts', :addon_type => 'theme', :addon => 'default', :format => 'js')
    end

    it 'recognizes and generates #styles' do
      { :get => '/assets/theme/default/styles.css' }.should route_to(:controller => 'assets', :action => 'styles', :addon_type => 'theme', :addon => 'default', :format => 'css')
      { :get => '/assets/theme/default/styles.sass' }.should route_to(:controller => 'assets', :action => 'styles', :addon_type => 'theme', :addon => 'default', :format => 'sass')
    end

    it 'recognizes and generates #static' do
      { :get => '/assets/theme/default/fonts/times.woff' }.should route_to(:controller => 'assets', :action => 'static', :addon_type => 'theme', :addon => 'default', :asset_type => 'fonts', :asset_name => 'times.woff')
      { :get => '/assets/theme/default/images/background.png' }.should route_to(:controller => 'assets', :action => 'static', :addon_type => 'theme', :addon => 'default', :asset_type => 'images', :asset_name => 'background.png')
      { :get => '/assets/theme/default/images/path/to/background.jpg' }.should route_to(:controller => 'assets', :action => 'static', :addon_type => 'theme', :addon => 'default', :asset_type => 'images', :asset_name => 'path/to/background.jpg')
    end

    it 'recognizes and generates #routes' do
      { :get => '/assets/routes' }.should route_to(:controller => 'assets', :action => 'routes')
    end
  end
end
