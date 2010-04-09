ScratchPad::Application.routes.draw do |map|
  resources :n, :controller => :nodes, :as => :nodes

  root :to => 'nodes#index'
end
