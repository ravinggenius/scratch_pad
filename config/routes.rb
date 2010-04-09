ScratchPad::Application.routes.draw do |map|
  resources :nodes

  root :to => 'nodes#index'
end
