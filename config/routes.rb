ScratchPad::Application.routes.draw do |map|
  resources :nodes, :only => [:index, :show]
  resources :sessions, :only => [:new, :create, :destroy]

  namespace :admin do
    resources :nodes, :except => :show
    root :to => 'dashboard#index'
  end

  namespace :assets do
    get '/routes', :to => :routes, :as => :routes
    get '/:template/scripts.:format', :to => :scripts, :as => :scripts, :defaults => { :format => :js }
    get '/:template/styles.:format', :to => :styles, :as => :styles, :defaults => { :format => :css }
  end

  root :to => 'nodes#index'
end
