ScratchPad::Application.routes.draw do |map|
  resources :n, :controller => :nodes, :as => :nodes

  get 'assets/styles'
  #get ':id' => redirect("nodes/%{id}"), :constraints => { :id => /\d+/ }

  root :to => 'nodes#index'
end
