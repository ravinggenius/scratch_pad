ScratchPad::Application.routes.draw do |map|
  resources :n, :controller => :nodes, :as => :nodes

  get 'assets/styles(.:format)', :to => 'assets#styles', :defaults => { :format => :css }
  #get ':id' => redirect("nodes/%{id}"), :constraints => { :id => /\d+/ }

  root :to => 'nodes#index'
end
