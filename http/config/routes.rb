ActionController::Routing::Routes.draw do |map|


  # Install the default routes as the lowest priority.
  map.subdomain :lib, :name=>:lib do |lib|
   lib.resources :site, :only=>[:index, :rss], :collection=>{:rss=>:get}
   lib.index '', :subdomains=>['lib'], :controller=>'site', :action=>'index'
   lib.rss '/rss', :subdomains=>['lib'], :controller=>'site', :action=>'rss'
   lib.resources :author
   lib.resources :book
#   lib.resources :author, :paged=>true
#   lib.resources :book, :paged=>true
   lib.resources :genre
   lib.resources :lang
  end
  map.subdomain nil, :name=>nil do |m|
  #map.subdomain nil, :www, :name=>nil do |m|
   m.resources :site, :only=>[:index, :sitemap, :contacts], :collection=>{:sitemap=>:get, :contacts=>:get}
   m.index '', :controller=>'site', :action=>'index'
#   m.index '', :subdomains=>['', 'www'], :controller=>'site', :action=>'index'
   m.sitemap '/sitemap.xml',  :controller=>'site', :action=>'sitemap', :format=>'xml'
#   m.sitemap '/sitemap.xml',:subdomains=>['', 'www'],  :controller=>'site', :action=>'sitemap', :format=>'xml'
   m.contacts '/contacts', :controller=>'site', :action=>'contacts'
#   m.contacts '/contacts',:subdomains=>['', 'www'], :controller=>'site', :action=>'contacts'
   m.resources :todo, :controller=>'Todo'
   #m.todo 'to_do/:action/:id', :controller=>'ToDo'
#  map.resources 'todo'
   m.resources :rails, :controller=>'Blog', :tag=>'rails'
   m.resources :articles
   m.resources :blog, :collection=>{ :rss=>:get }, :member=>{ :named=>:get, :dated=>:get } do | post |
    post.resources :comments
   end
   m.resources :tag
   m.resources :user, :collection=>{:login=>:get, :logit=>:post, :logout=>:get}
   m.resources :stats
   m.resources :session, :only=>[:new, :create, :delete]
   m.resources :config
#   m.ajax 'ajax/:action/:id', :controller=>'Ajax'
  end
end
