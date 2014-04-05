Afalone::Application.routes.draw do

 namespace :blog do
   root to: 'posts#index'
   resources :posts , controller: :posts do
     collection do
       get :rss
     end
     resources :comments, shallow: true
     #resources :comments, :only => [:index, :new, :create]
   end
   #resources :comments, :only => [:show, :edit, :update, :delete]
 end
 namespace :lib do
  resources :site do
   collection do
    get :rss
   end
  end
  root :to => 'site#index'
  #match '/' => 'site#index', :as => :index
  get '/rss' => 'site#rss', :as => :rss
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
 get '/sitemap.xml' => 'site#sitemap', :as => :sitemap, :format => 'xml'
 get '/contacts' => 'site#contacts', :as => :contacts
 get '/rss.xml' => 'site#rss', :as => :rss
 resources :todo
 resources :rails
 resources :articles
 #resources :blogs do
 # collection do
 #  get :rss
 # end
 # resources :comments
 #end

 resources :tag
 resources :users #do
 # collection do
 #  get :login, :as => :login
 #  post :logit
 #  get :logout
 # end
 #end

 resources :stats
 #resources :session, :only => [:new, :create, :destroy]
 resources :config
end

