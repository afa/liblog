class Book < ActiveRecord::Base

# has_one :cover, :source=>:things, :as=>:thingable
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
   cover = self.generate_cover
   pages = self.generate_testpages
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
   return false unless File.exist? file_name
   doc = self.load_xml(file_name)
   return false unless doc
   fb2_guid = self.extract_xml_part(doc, '//document-info//id').first.andand.content
   return false if fb2_guid.blank?
   return false if Book.find_by_fbguid(fb2_guid)
   title = self.extract_xml_part(doc, '//description//title-info//book-title').first.andand.content
   title = Iconv.iconv('utf-8', doc.encoding, title).join('')
   book = Book.create(:fbguid=>fb2_guid, :name=>title, :file_name=>File.basename(file_name))
   book.valid?
  end

  def self.load_xml(fname)
   doc = nil
   File.open(fname, 'r') do |file|
    doc = Nokogiri::XML(file, nil, 'utf-8')
   end
   return nil unless doc
   doc.remove_namespaces!
   doc
  end

  def self.extract_xml_part(doc, part)
   doc.xpath(part)
  end

  def self.parse_fb2(fname)
    doc = self.load_xml(fname)
    return nil unless doc
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

  def generate_cover
   doc = Book.load_xml(self.working_file)
   page = Book.extract_xml_part(doc, '//description//title-info//coverpage/image').first
   raise ErrorNoCover if page.nil?
   raise ErrorNoCover if page.attributes['href'].nil?
   cname = page.attributes['href'].value.scan(/#(.+)/)[0][0]
   bins = Book.extract_xml_part(doc, '//binary')
   bin = nil
   bins.each do |e|
    next unless e.attributes['content-type'].andand.value =~ /^image\//
    next unless e.attributes['id'].andand.value == cname
    bin = e.content
   end
   raise ErrorNoCover unless bin
   c = Base64.decode64(bin)
   cover = nil
   Tempfile.open('/tmp_cover') do |f|
    f << c
    self.covers << cover = Cover.new(:name => "book_cover_#{cname}", :file => f)
   end
   cover
  end

  def generate_testpages
  end

  def working_file
   File.join(WORKING_DIR, self.file_name.to_s)
  end

 private
  def update_count
   self.authors.each{|a| a.update_books_count}
   self.genres.each{|a| a.update_books_count}
   #self.lang.update_books_count
  end

end

 class ErrorNoCover < Exception; end
 class ErrorNoText < Exception; end
 class ErrorNoWorkFile < Exception; end
