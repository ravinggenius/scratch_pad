ScratchPad::Application.routes.draw do |map|
  resources :n, :controller => :nodes, :as => :nodes

  #get ':id' => redirect("nodes/%{id}"), :constraints => { :id => /\d+/ }

  #namespace 'assets' do
  #  get '/application.css', :to => 'styles#show'
  #end

  root :to => 'nodes#index'
end
