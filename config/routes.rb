ScratchPad::Application.routes.draw do
  resources :nodes, :only => [:index, :show]
  resources :sessions, :only => [:new, :create, :destroy]
  resources :users, :only => [:index, :show]

  namespace :admin do
    resources :addons, :only => :index
    resources :filter_groups
    resources :nodes, :except => :show
    resources :settings
    resources :themes, :only => :index do
      resources :layouts, :only => [:edit, :update]
    end
    resources :users
    resources :vocabularies, :except => :show do
      resources :terms, :except => :show
    end
    [:addons, :themes].each do |controller|
      post "/#{controller}", :to => "#{controller}#update"
    end
    get '/nodes/new_node_type', :to => 'nodes#new_node_type'
    root :to => 'dashboard#index'
  end

  namespace :assets do
    get '/routes', :to => :routes, :as => :routes
    get '/:theme/scripts(.:format)', :to => :scripts, :as => :scripts, :defaults => { :format => :js }
    get '/:theme/styles(.:format)', :to => :styles, :as => :styles, :defaults => { :format => :css }
  end

  root :to => 'nodes#index'
end
