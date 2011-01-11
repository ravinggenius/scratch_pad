ScratchPad::Application.routes.draw do
  get '/login', :to => 'sessions#new', :as => :new_session

  resources :nodes, :only => [:index, :show]
  resources :sessions, :only => [:create, :destroy]
  resources :users, :only => [:index, :show]

  namespace :admin do
    resources :addons, :only => :index
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
    [:addons, :themes].each do |controller|
      post "/#{controller}", :to => "#{controller}#update"
    end
    get '/nodes/new_node_type', :to => 'nodes#new_node_type'
    root :to => 'dashboard#index'
  end

  namespace :assets do
    get '/routes', :to => :routes, :as => :routes
    get '/:addon/images/*image_name', :to => :image, :as => :image
    get '/:theme/fonts/*font_name', :to => :font, :as => :font
    get '/:theme/scripts(.:format)', :to => :scripts, :as => :scripts, :defaults => { :format => :js }
    get '/:theme/styles(.:format)', :to => :styles, :as => :styles, :defaults => { :format => :css }
  end

  get '/*path', :to => 'nodes#show_human', :as => :human_node

  root :to => 'nodes#index'
end
