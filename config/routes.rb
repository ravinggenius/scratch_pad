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

  # static files (fonts, images etc) are handled by Rack::Static after their first request (they are copied into ./tmp)
  # theme scripts and styles should have proper cache expiring, and really only need to be concatenated in production
  namespace :assets do
    get '/:addon_type/:addon/scripts.:format', :to => :scripts, :as => :scripts, :defaults => { :addon_type => :theme, :format => :js }
    get '/:addon_type/:addon/styles.:format', :to => :styles, :as => :styles, :defaults => { :addon_type => :theme, :format => :css }
    get '/:addon_type/:addon/:asset_type/*asset_name', :to => :static, :as => :static
    get '/routes', :to => :routes, :as => :routes
  end

  get '/*path', :to => 'nodes#show_human', :as => :human_node

  root :to => 'home#index'
end
