class Blog::Post < ActiveRecord::Base
  self.table_name = Blog::Config.config.post.table_name

  belongs_to :user
  scope :lasts, -> { order('created_at DESC') }
  scope :only_50, -> { limit(50) }
  scope :accessible, -> { where(:state => ['published', 'prepared']) }
  scope :active, -> { where(:state => 'published') }

  has_many :comments, class_name: Blog::Comment, foreign_key: :blog_post_id
  def to_param
    name.blank? ? super : [id.to_s, '-', name].join
  end

end
