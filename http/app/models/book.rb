class Book < ActiveRecord::Base
 has_many :covers, :source=>:things, :as=>:thingable
 has_and_belongs_to_many :authors
 has_and_belongs_to_many :genres
 belongs_to :lang, :counter_cache=>true
 belongs_to :bundle, :counter_cache=>true

 after_save :update_count

 named_scope :unbundled, lambda { {:conditions=>"state not in ('bundled', 'published')"} }
 named_scope :only_50, {:limit=>50}
 named_scope :lasts, {:order=>'created_at DESC'}
 named_scope :with_authors, {:include=>[:authors]}
 named_scope :active, {:conditions => {:state => 'published'}}

 include AASM

 aasm_column :state

 aasm_initial_state :created

 aasm_state :created # создан. остальное без гарантий
 aasm_state :prepared, :after_enter => :process_media#, :exit=>
# авторы, язык, аннотация, обложка, превью etc подготовлены.
 aasm_state :bundled #.fb2.desc и .fb2 упакованы
 aasm_state :published # активна
 aasm_state :blocked, :after_enter => :process_block

 aasm_event :prepare do
  transitions :to => :prepared, :from => [:created], :guard => :check_book_fields
 end
 aasm_event :to_bundled do
  transitions :to => :bundled, :from => [:prepared], :guard => :check_bundled
 end
 aasm_event :publish do
  transitions :to => :published, :from => [:bundled], :guard => :check_ready
 end
 aasm_event :block do
  transitions :to => :blocked, :from =>[:created, :prepared, :bundled, :published]
 end
 aasm_event :restart do
  transitions :to => :created, :from => [:blocked]
 end
 ## callbacks, guards (protected)
  def check_ready
   false
  end

  def check_bundled
   false
  end

  def check_book_fields
   false
  end

  def process_media
  end

  def process_block
  end
 #end aasm

 def Book.per_page
  30
 end

  def parse_fb2(fname)
   
  end

  def authors=(str)
  end

  def parse_fb2(fname)
    doc = Nokogiri::XML(f, nil, 'utf-8')
    doc.remove_namespaces!
    body = doc.xpath('//body').to_xml
    sections = []
    #sdoc = Nokogiri::XML(body, nil, 'utf-8')
    #sdoc.remove_namespaces!
    #p sdoc
    doc.xpath('//body/section').each { |section| sections << section }
    titles = []
    #p sections.first
    puts sections.size
    sections.each_with_index do |section, idx|
     ttl = section.xpath('//title')
     titles[idx] = ttl.first.content unless ttl.blank?
     pages << Testpage.generate_pages(self, section.content, titles[idx] || '')
    end
  end

 private
  def update_count
   self.authors.each{|a| a.update_books_count}
   self.genres.each{|a| a.update_books_count}
   #self.lang.update_books_count
  end
 
end
