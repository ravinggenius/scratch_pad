require 'spec_helper'

describe NodesController do
  describe 'routing' do
    it 'recognizes and generates #index' do
      { :get => '/nodes' }.should route_to(:controller => 'nodes', :action => 'index')
    end

    it 'recognizes and generates #show' do
      #{ :get => '/nodes/1' }.should redirect_to('/1')
      { :get => '/nodes/1.json' }.should route_to(:controller => 'nodes', :action => 'show', :id => '1', :format => 'json')
    end

    it 'recognizes and generates #show_human' do
      #{ :get => '/1.json' }.should redirect_to('/nodes/1.json')
      { :get => '/1' }.should route_to(:controller => 'nodes', :action => 'show_human', :path => '1')
      { :get => '/1.html' }.should route_to(:controller => 'nodes', :action => 'show_human', :path => '1.html')
      { :get => '/about' }.should route_to(:controller => 'nodes', :action => 'show_human', :path => 'about')
      { :get => '/about/us' }.should route_to(:controller => 'nodes', :action => 'show_human', :path => 'about/us')
      { :get => '/about/us.htm' }.should route_to(:controller => 'nodes', :action => 'show_human', :path => 'about/us.htm')
      { :get => '/about/us.html' }.should route_to(:controller => 'nodes', :action => 'show_human', :path => 'about/us.html')
      { :get => '/about/us.xhtml' }.should route_to(:controller => 'nodes', :action => 'show_human', :path => 'about/us.xhtml')
    end
  end
end
