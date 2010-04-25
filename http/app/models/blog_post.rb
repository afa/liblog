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
end
#class String
# def smart_trim(byte_len)
#  self.length > byte_len ? self.chars[0,self[0..byte_len].chars.rindex(/\s/)-1] + '...' : self
# end
#end

class BlogPost < ActiveRecord::Base

 include AASM

 aasm_column :state
 aasm_initial_state :created

 aasm_state :created
 aasm_state :imported
 aasm_state :prepared
 aasm_state :published
 aasm_state :removed

 aasm_event :import do
  transitions :to => :imported, :from => :created
 end

 aasm_event :prepare do
  transitions :to => :prepared, :from => [ :created, :imported ]
 end

 # END aasm
 acts_as_taggable_on :tags
 has_many :photos, :source=>:things, :as=>:thingable
# before_save :trim_fields
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
 def trim_fields
  #self.title = self.title.smart_trim(250) if self.title and self.title.length >255
  #self.name = self.name.smart_trim(250) if self.name and self.name.length >255
 end
end
