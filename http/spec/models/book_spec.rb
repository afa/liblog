require 'spec_helper'

describe Book do
 before(:each) do
  @book = Factory(:book)
 end
 it "should has method per_page with default value 30" do
  Book.should be_respond_to(:per_page)
  Book.per_page.should === 30
 end
 should "register working fb2 from file" do
  assert Book.respond_to? :register_working_fb2
 end
 describe "on register_working_fb2" do
  before(:each) do
   @name=File.join(INPUT_DIR, 'in.fb2')
  end
  should "fail on unexistence of in file" do
   File.expects(:exist?).with(@name).at_least_once.returns(false)
   assert !Book.register_working_fb2(@name)
  end
  describe "with zero length file" do
   before(:each) do
    `touch #{@name}`
   end
   should "load_xml and return nil" do
    File.expects(:exist?).with(@name).at_least_once.returns(true)
    Book.expects(:load_xml).with(@name).once.returns(nil)
    assert !Book.register_working_fb2(@name)
   end
   after(:each) do
    `rm #{@name}`
   end
  end
  describe "with real fb2 like file" do
   before(:each) do
    @name = File.join(INPUT_DIR, 'in.fb2')
    FileUtils.cp 'test/testdata/24.fb2', @name
    @count = Book.count
   end
   should "fail on extracting blank fbguid" do
    Book.expects(:extract_xml_part).at_least_once.returns([]) #REFACTOR to use .with(Nokogiri::XML::Document, '//document-info//id')
    assert !Book.register_working_fb2(@name)
   end
   should "fail on existence of working file with guid" do
    Book.expects(:find_by_fbguid).with('Mon Jun 10 19:57:41 2013').once.returns(Book.make(:fbguid=>'Mon Jun 10 19:57:41 2013'))
    assert !Book.register_working_fb2(@name)
   end
   should "check nonexistence of working file with guid" do
    Book.expects(:find_by_fbguid).with('Mon Jun 10 19:57:41 2013').once.returns(nil)
    assert Book.register_working_fb2(@name)
   end
   should "extract name from file" do
    Book.expects(:create).once.with(:name=>'Белка', :fbguid=>'Mon Jun 10 19:57:41 2013', :file_name=>File.basename(@name)).returns(Book.new)
    Book.register_working_fb2(@name)
   end
   should "create valid book" do
    assert Book.register_working_fb2(@name)
    assert_in_delta Book.count, @count, 1
   end
   should "convert name to utf-8 from src encoding"
   should "move file from in to work catalog"
   should "setup file_name"
   after(:each) do
    FileUtils.rm @name
   end
  end
#  should "extract lre_title from file"
#  should "extract lre_annotation from file"
#  should "extract lang from file"
#  should "setup extracted lang"
#  should "extract authors from file"
#  should "ask Author to create authors from extractedlist of hashes"
 end
 describe "state machine" do
  describe "initialy" do
   before(:each) do
    @inited = Book.make
   end
   should "be in created state" do
    assert_equal @inited.state, 'created'
   end
  end

  describe "in state created" do
   before(:each) do
    #@author = Author.make
    #@lang = Lang.make
    `touch test/testdata/work/in.fb2`
    @created = Book.make :state => 'created', :file_name=>'in.fb2'
   end
   subject {@created}
   should "respond to prepare" do
    assert @created.respond_to? :prepare
   end
   describe "on prepare" do
    should "test check_book_fields and exec process_media" do
     @created.expects(:check_book_fields).once.returns(true)
     @created.expects(:process_media).once
     assert @created.prepare
    end
    should "fail on check_book_fields returning false" do
     @created.expects(:check_book_fields).once.returns(false)
     assert !@created.prepare
    end
    should "run process_media" do
     @created.expects(:process_media)
     @created.prepare
    end
   end
   after(:each) do
    `rm test/testdata/work/in.fb2`
   end
  end

  describe "in prepared state" do
   before(:each) do
    @prepared = Book.make :state=>'prepared'
   end
   subject { @prepared }
   should "respond to to_bundled" do
    assert @prepared.respond_to? :to_bundled
   end
   describe "on to_bundled" do
    should "run prepare_bundle" do
     @prepared.expects(:prepare_bundle).once
     @prepared.expects(:check_bundled).once.returns(true)
     @prepared.to_bundled
    end
   end
  end

  describe "in bundled state" do
   before(:each) do 
    @bundled = Book.make(:state=>'bundled')
   end
   should "respond to publish" do
    assert @bundled.respond_to? :publish
   end
   describe "on publish" do
    should "success when allow_publish? return true" do
     @bundled.expects(:allow_publish?).once.returns(true)
     assert @bundled.publish
    end
    should "fail when allow_publish? return false" do
     @bundled.expects(:allow_publish?).once.returns(false)
     assert !@bundled.publish
    end
   end
  end
 end

 describe "on check_book_fields" do
  before(:each) do
   @annotated = Book.make :state => 'created', :file_name=>'in.fb2'
   @unannotated = Book.make :state => 'created', :annotation => nil
   @badannotated = Book.make :state => 'created', :annotation => '   '
  end
  should "allow valid annotation" do
   assert @annotated.check_book_fields
  end
  should "not allow blank annotation" do
   assert !@badannotated.check_book_fields
  end
  should "allow nil annotation" do
   assert @unannotated.check_book_fields
  end
 end

 describe "on process_media" do
  before(:each) do
   @name = File.join(WORKING_DIR, "#{rand(999)+1}.fb2")
   FileUtils.cp 'test/testdata/24.fb2', @name
   @book = Book.make :file_name => @name
  end
  should "call generate_cover" do
   @book.expects(:generate_cover).once
   @book.process_media
  end
  should "call generate_cover and then generate_testpages" do
   @book.expects(:generate_cover).once
   @book.expects(:generate_testpages).once
   @book.process_media
  end
  after(:each) do
   FileUtils.rm @name
  end
 end

 describe "on generate_cover" do
  before(:each) do
   @noncover = File.join(WORKING_DIR, "#{rand(999)+1}.fb2")
   @cover = File.join(WORKING_DIR, "#{(999)+1000}.fb2")
   FileUtils.cp 'test/testdata/193937.fb2', @cover
   FileUtils.cp 'test/testdata/24.fb2', @noncover
   @covered = Book.make :file_name => File.basename(@cover)
   @noncovered = Book.make :file_name => File.basename(@noncover)
  end
  should "raise ErrorNoCover when cover not found in file" do
   assert_raises ErrorNoCover do
    @noncovered.generate_cover
   end
  end
  should "not raise any when cover exists" do
   assert_nothing_raised do
    @covered.generate_cover
   end
  end
  should "extract cover and return it" do
   assert_kind_of Cover, @covered.generate_cover
  end
  after(:each) do
   FileUtils.rm @cover
   FileUtils.rm @noncover
  end
 end

 describe "on generate_testpages" do
 end

 describe "on working_file" do
  should "return path to fb2 in work dir" do
   assert @book.working_file =~ /^#{WORKING_DIR.gsub('/', '\/')}/
  end
 end

#  should have_many :covers
#  should have_and_belong_to_many :authors
#  should have_and_belong_to_many :genres
#  should belong_to :lang
#  should belong_to :bundle
#  should validate_uniqueness_of :fbguid
#  should validate_presence_of :name
end
