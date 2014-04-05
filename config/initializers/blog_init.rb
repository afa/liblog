Blog::Config.setup do |config|
  config.post.table_name = :my_blog_posts
  config.comment.table_name = :my_blog_comments
end
