require 'spec_helper'

describe Admin::VocabulariesController do
  describe 'routing' do
    it 'recognizes and generates #index' do
      { :get => '/admin/vocabularies' }.should route_to(:controller => 'admin/vocabularies', :action => 'index')
    end

    it 'recognizes and generates #new' do
      { :get => '/admin/vocabularies/new' }.should route_to(:controller => 'admin/vocabularies', :action => 'new')
    end

    it 'recognizes and generates #edit' do
      { :get => '/admin/vocabularies/1/edit' }.should route_to(:controller => 'admin/vocabularies', :action => 'edit', :id => '1')
    end

    it 'recognizes and generates #create' do
      { :post => '/admin/vocabularies' }.should route_to(:controller => 'admin/vocabularies', :action => 'create')
    end

    it 'recognizes and generates #update' do
      { :put => '/admin/vocabularies/1' }.should route_to(:controller => 'admin/vocabularies', :action => 'update', :id => '1')
    end

    it 'recognizes and generates #destroy' do
      { :delete => '/admin/vocabularies/1' }.should route_to(:controller => 'admin/vocabularies', :action => 'destroy', :id => '1')
    end
  end
end
