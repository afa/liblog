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
  map.subdomain nil, :www, :name=>nil do |m|
   m.resources :site, :only=>[:index, :sitemap, :contacts], :collection=>{:sitemap=>:get, :contacts=>:get}
   m.index '', :subdomains=>['', 'www'], :controller=>'site', :action=>'index'
   m.sitemap '/sitemap.xml',:subdomains=>['', 'www'],  :controller=>'site', :action=>'sitemap', :format=>'xml'
   m.contacts '/contacts',:subdomains=>['', 'www'], :controller=>'site', :action=>'contacts'
   #m.todo 'to_do/:action/:id', :controller=>'ToDo'
#  map.resources 'todo'
   m.resources :blog, :collection=>{ :rss=>:get }, :member=>{ :named=>:get, :dated=>:get } do | post |
    post.resources :comments
   end
   m.resources :user, :collection=>{:login=>:get, :logit=>:post, :logout=>:get}
   m.resources :stats
   m.resources :session, :only=>[:new, :create, :delete]
#  map.connect 'blog/:action/:id', :controller=>'Blog', :requirements=>{:id=>/\d+/}
#   m.ajax 'ajax/:action/:id', :controller=>'Ajax'
#  map.blog_named 'blog/show/:name', :controller=>'Blog', :action=>'named'
#  map.connect 'blog/:year/:month/:day', :controller=>'Blog', :action=>'dated'
#  map.connect 'blog/:year/:month', :controller=>'Blog', :action=>'dated'
  end
#  map.connect ':controller/:action/:id'
#  map.connect ':controller/:action/:id.:format'
end
