require "bluecloth"
class Convertor
 def self.to_markdown(src) #to internal
  src
 end
 
 def self.to_html(src) #to view
  src
 end

 def self.split(src) #split cutted
  src
 end

 def self.join(*src) #join cutted text with cut line and last part
  src.join('')
 end
end

class MarkdownConvertor < Convertor
 def self.to_html(src)
  Markdown.new(src).to_html
 end
end

class BlogPost < ActiveRecord::Base

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
