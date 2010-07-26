ScratchPad::Application.routes.draw do |map|
  scope :path_names => { :new => 'n', :edit => 'e' } do
    resources :n, :controller => :nodes, :as => :nodes, :only => [:index, :show]
    resources :s, :controller => :sessions, :as => :sessions, :only => [:new, :create, :destroy]
  end

  namespace 'admin' do
    resources :nodes, :only => [:new, :create, :edit, :update, :destroy]
    root :to => 'dashboard#index'
  end

  get 'a(/:template)/scripts(.:format)', :to => 'assets#scripts', :as => :assets_scripts, :defaults => { :format => :js }
  get 'a(/:template)/styles(.:format)', :to => 'assets#styles', :as => :assets_styles, :defaults => { :format => :css }

  root :to => 'nodes#index'
end
