ScratchPad::Application.routes.draw do
  get '/login', :to => 'sessions#new', :as => :new_session

  resources :nodes, :only => [:index, :show]
  resources :sessions, :only => [:create, :destroy]
  resources :users, :only => [:index, :show]

  namespace :admin do
    resources :filter_groups, :except => :show
    resources :nodes, :except => :show
    resources :settings, :except => [:new, :create, :destroy]
    resources :themes, :only => :index do
      resources :layouts, :only => [:edit, :update]
    end
    resources :users
    resources :vocabularies, :except => :show do
      resources :terms, :except => :show
    end
    get '/addon_configurations(/:addon_type)', :to => 'addon_configurations#index', :as => :addon_configurations
    post '/addon_configurations(/:addon_type)', :to => 'addon_configurations#update'
    get '/nodes/new_node_type', :to => 'nodes#new_node_type'
    post '/themes', :to => 'themes#update'
    root :to => 'dashboard#index'
  end

  namespace :assets do
    get '/routes', :to => :routes, :as => :routes
    get '/:addon_type/:addon/:asset_type/*asset_name', :to => :static, :as => :static
    get '/:theme/scripts.:format', :to => :scripts, :as => :scripts, :defaults => { :format => :js }
    get '/:theme/styles.:format', :to => :styles, :as => :styles, :defaults => { :format => :css }
  end

  get '/*path', :to => 'nodes#show_human', :as => :human_node

  root :to => 'nodes#index'
end
