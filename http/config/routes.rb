ActionController::Routing::Routes.draw do |map|

  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  map.subdomain :lib, :name=>:lib do |lib|
   lib.index '', :controller=>'Site', :action=>'index'
   lib.resources :author
   lib.resources :book
   lib.resources :site
  end
  map.subdomain nil, :www, :name=>nil do |m|
  m.connect '', :controller=>'Site', :action=>'index'
  m.connect '/sitemap.xml', :controller=>'Site', :action=>'sitemap', :format=>'xml'
  m.connect '/contacts', :controller=>'Site', :action=>'contacts'
  m.todo 'to_do/:action/:id', :controller=>'ToDo'
#  map.resources 'todo'
  m.resources :blog, :collection=>{ :rss=>:get }, :member=>{ :named=>:get, :dated=>:get } do | post |
   post.resources :comments
  end
  m.resources :stats
#  map.connect 'blog/:action/:id', :controller=>'Blog', :requirements=>{:id=>/\d+/}
  m.ajax 'ajax/:action/:id', :controller=>'Ajax'
#  map.blog_named 'blog/show/:name', :controller=>'Blog', :action=>'named'
#  map.connect 'blog/:year/:month/:day', :controller=>'Blog', :action=>'dated'
#  map.connect 'blog/:year/:month', :controller=>'Blog', :action=>'dated'
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
  end
end
