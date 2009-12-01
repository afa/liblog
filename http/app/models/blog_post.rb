class LivejournalConvertor

 def text_convert(src)
  src
 end

end

class String
 def smart_trim(byte_len)
  self.length > byte_len ? self.chars[0,self[0..byte_len].chars.rindex(/\s/)-1] + '...' : self
 end
end

class BlogPost < ActiveRecord::Base

 has_many :photos, :source=>:things, :as=>:thingable
 before_save :trim_fields
 has_one :imported_entry
 cattr_reader :per_page
 @@per_page = 20
 belongs_to :identity
 has_many :comments, :class_name=>'BlogComment', :foreign_key=>'blog_post_id', :order=>'created_at'
 has_many :imm_comments, :class_name=>'BlogComment', :foreign_key=>'blog_post_id', :conditions=>'blog_comment_id is null', :order=>'created_at'

  named_scope :lasts, {:order=>'created_at DESC'}
  named_scope :only_50, {:limit=>50}

 def permalink
  self.name
 end 
 def trim_fields
  #self.title = self.title.smart_trim(250) if self.title and self.title.length >255
  #self.name = self.name.smart_trim(250) if self.name and self.name.length >255
 end
end
