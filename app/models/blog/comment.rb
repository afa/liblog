class Blog::Comment < ActiveRecord::Base
  self.table_name = Blog::Config.config.comment.table_name

  belongs_to :post, class_name: Blog::Post, foreign_key: :blog_post_id
  belongs_to :commenter, class_name: User

  scope :lasts, -> { order('created_at desc') }
end
