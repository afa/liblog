# coding: UTF-8
require "bluecloth"
class Convertor
 attr :body, :header
 attr_accessor :body, :header
 def self.import #to markdown
 end
 def self.prepare #to hash for save viewable text from markdowns
 end
 
 def self.restore #
 end
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
 belongs_to :user
 has_many :comments, :class_name=>'BlogComment', :foreign_key=>'blog_post_id', :order=>'created_at'
 has_many :imm_comments, :class_name=>'BlogComment', :foreign_key=>'blog_post_id', :conditions=>'blog_comment_id is null', :order=>'created_at'

 scope :lasts, order('created_at DESC')
 scope :only_50, limit(50)
 scope :accessible, where(:state => ['published', 'prepared'])
 scope :active, where(:state => 'published')

 before_validation :prerender_body
  def convertor
   class_eval((raw_type || 'Simple') + 'Convertor')
  end

  def permalink
   self.name
  end 

  def prerender_body
   #convert raw_text, raw_header, raw_tail, raw_cut_string to title, text, cutted_text
  end
end
