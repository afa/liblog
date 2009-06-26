class String
 def smart_trim(byte_len)
  self.length > byte_len ? self.chars[0,self[0..byte_len].chars.rindex(/\s/)-1] + '...' : self
 end
end
class BlogPost < ActiveRecord::Base
 before_save :trim_fields
 has_one :imported_entry
 cattr_reader :per_page
 @@per_page = 20
 belongs_to :identity
 has_many :blog_comments
 def permalink
  self.name
 end 
 def trim_fields
  self.title = self.title.smart_trim(250) if self.title and self.title.length >255
  self.name = self.name.smart_trim(250) if self.name and self.name.length >255
 end
end
