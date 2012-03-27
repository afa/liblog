Afalone::Application.routes.draw do
  get "blogs/index"

  get "blogs/show"

  get "blogs/edit"

  get "blogs/update"

  get "blogs/create"

  get "blogs/new"

  get "blogs/rss"

 namespace :lib do
  resources :site do
   collection do
    get :rss
   end
  end
  root :to => 'site#index'
  #match '/' => 'site#index', :as => :index
  match '/rss' => 'site#rss', :as => :rss
  resources :author
  resources :book
  resources :genre
  resources :lang
 end

 resources :site do
  collection do
   get :sitemap
   get :contacts
  end
 end

 root :to => 'site#index'
 #match '' => 'site#index', :as => :index
 match '/sitemap.xml' => 'site#sitemap', :as => :sitemap, :format => 'xml'
 match '/contacts' => 'site#contacts', :as => :contacts
 match '/rss' => 'site#rss', :as => :rss
 resources :todo
 resources :rails
 resources :articles
 resources :blogs do
  resources :comments
 end

 resources :tag
 resources :users do
  collection do
   get :login, :as => :login
   post :logit
   get :logout
  end
 end

 resources :stats
 resources :session
 resources :config
end

