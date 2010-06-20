class Convertor

  def self.text_to_hash(src)
  end

  def self.title_to_ml(src)
  end

  def self.ml_to_title(src)
  end

  def self.hash_to_text(src)
  end
end


class LivejournalConvertor < Convertor

  def self.text_to_hash(src)
  # return hash {:short=>, :cut_phrase=>, :text}
  # разобрать на части, 
  # self.
  end

  def self.title_to_ml(src)
   #убрать опасные теги, преобразовать разрешенные, урезать в размере
   self.convert_tags(self.process_tags(src))
  end
 protected
  def self.convert_tags(src)
   src.mb_chars.gsub('<', '&lt;')
  end

  def self.process_tags(src)
   result = {}
   src.scan(/<lj-cut(\s+text="(.+?)")>/)
  end
end

class SimpleConvertor < Convertor
 def self.text_to_hash(src)
  {:short => src, :cut_phrase=>nil, :text=>nil}
 end

 def self.hash_to_text(hash)
  hash[:short]
 end
end

class BlogPost < ActiveRecord::Base

# include AASM
#
# aasm_column :state
# aasm_initial_state :created
#
# aasm_state :created
# aasm_state :imported
# aasm_state :prepared
# aasm_state :published
# aasm_state :removed
#
# aasm_event :import do
#  transitions :to => :imported, :from => :created
# end
#
# aasm_event :prepare do
#  transitions :to => :prepared, :from => [ :created, :imported ]
# end
#
# # END aasm
 acts_as_taggable_on :tags
 has_many :photos, :source=>:things, :as=>:thingable
 has_one :imported_entry
 cattr_reader :per_page
 @@per_page = 20
 belongs_to :identity
 has_many :comments, :class_name=>'BlogComment', :foreign_key=>'blog_post_id', :order=>'created_at'
 has_many :imm_comments, :class_name=>'BlogComment', :foreign_key=>'blog_post_id', :conditions=>'blog_comment_id is null', :order=>'created_at'

 named_scope :lasts, {:order=>'created_at DESC'}
 named_scope :only_50, {:limit=>50}
 named_scope :accessible, {:conditions => {:state => ['published', 'prepared']}}
 named_scope :active, {:conditions => {:state => 'published'}}

  def convertor
   class_eval((raw_type || 'Simple') + 'Convertor')
  end

 def permalink
  self.name
 end 
end
