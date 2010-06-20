class Book < ActiveRecord::Base
 has_many :covers, :source=>:things, :as=>:thingable
 has_and_belongs_to_many :authors
 has_and_belongs_to_many :genres
 belongs_to :lang, :counter_cache=>true
 belongs_to :bundle, :counter_cache=>true

 validates_uniqueness_of :fbguid, :nil=>true
 validates_presence_of :name, :blank=>false
 after_save :update_count

 named_scope :unbundled, lambda { {:conditions=>"state not in ('bundled', 'published')"} }
 named_scope :only_50, {:limit=>50}
 named_scope :lasts, {:order=>'created_at DESC'}
 named_scope :with_authors, {:include=>[:authors]}
 named_scope :active, {:conditions => {:state => 'published'}}

 state_machine :state, :initial=>:created do

  event :prepare do
   transition :created => :prepared, :if => :check_book_fields
  end
  after_transition :created=>:prepared, :do => :process_media

  event :to_bundled do
   transition :prepared => :bundled, :if => :check_bundled
  end
  before_transition :prepared => :bundled, :do => :prepare_bundle

  event :publish do
   transition :bundled => :published, :if => :allow_publish?
  end

  state :created
  state :prepared
  state :bundled
  state :published
  state :blocked
 end
  def allow_publish?
   false
  end

  def check_book_fields
   return false if self.annotation.blank? and !self.annotation.nil?
   true
  end
  def check_bundled
   false
  end
 #eog
  def process_media
  end
 #eow
 #eo state_machine
# aasm_state :created # создан. остальное без гарантий
# aasm_state :prepared, :after_enter => :process_media#, :exit=>
## авторы, язык, аннотация, обложка, превью etc подготовлены.
# aasm_state :bundled #.fb2.desc и .fb2 упакованы
# aasm_state :published # активна
# aasm_state :blocked, :after_enter => :process_block

 def Book.per_page
  30
 end

  def authors=(str)
  end

  def self.register_working_fb2(file_name)
   false
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
