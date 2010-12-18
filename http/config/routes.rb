ActionController::Routing::Routes.draw do |map|


  # Install the default routes as the lowest priority.
  map.namespace :lib do |lib|
  #map.subdomain :lib, :name=>:lib do |lib|
   lib.resources :site, :only=>[:index, :rss], :collection=>{:rss=>:get}
   #lib.index '', :subdomains=>['lib'], :controller=>'site', :action=>'index'
   lib.index '', :controller=>'site', :action=>'index'
   #lib.rss '/rss', :subdomains=>['lib'], :controller=>'site', :action=>'rss'
   lib.rss '/rss', :controller=>'site', :action=>'rss'
   lib.resources :author
   lib.resources :book
#   lib.resources :author, :paged=>true
#   lib.resources :book, :paged=>true
   lib.resources :genre
   lib.resources :lang
  end
  #map.subdomain nil, :name=>nil do |m|
  #map.subdomain nil, :www, :name=>nil do |m|
   map.resources :site, :only=>[:index, :sitemap, :contacts], :collection=>{:sitemap=>:get, :contacts=>:get}
   map.index '', :controller=>'site', :action=>'index'
   map.sitemap '/sitemap.xml',  :controller=>'site', :action=>'sitemap', :format=>'xml'
   map.contacts '/contacts', :controller=>'site', :action=>'contacts'
   map.resources :todo, :controller=>'Todo'
   #m.todo 'to_do/:action/:id', :controller=>'ToDo'
#  map.resources 'todo'
   map.resources :rails, :controller=>'Blog', :tag=>'rails'
   map.resources :articles
   map.resources :blog, :collection=>{ :rss=>:get }, :member=>{ :named=>:get, :dated=>:get } do | post |
    post.resources :comments
   end
   map.resources :tag
   map.resources :user, :collection=>{:login=>:get, :logit=>:post, :logout=>:get}
   map.resources :stats
   map.resources :session, :only=>[:new, :create, :delete]
   map.resources :config
#   m.ajax 'ajax/:action/:id', :controller=>'Ajax'
  #end
end
