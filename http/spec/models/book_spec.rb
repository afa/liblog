require 'spec_helper'

describe Book do
 it "should has method per_page with default value 30" do
  Book.should be_respond_to(:per_page)
  Book.per_page.should === 30
 end
 it "shoulf register working fb2 from file" do
  Book.should be_respond_to(:register_working_fb2)
 end
 describe "on register_working_fb2" do
  before(:each) do
   @name=File.join(INPUT_DIR, 'in.fb2')
  end
  it "fail on unexistence of in file" do
   File.stub!(:exist?).with(@name).and_return(false)
   Book.register_working_fb2(@name).should_not be_true
  end
  describe "with zero length file" do
   before(:each) do
    `touch #{@name}`
   end
   it "load_xml and return nil" do
    File.stub!(:exist?).with(@name).and_return(true)
    Fb2.stub!(:load_xml).with(@name).and_return(nil)
    Book.register_working_fb2(@name).should_not be_true
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
   it "fail on extracting blank fbguid" do
    @doc = Nokogiri::XML::Document.new
    p @doc
    Fb2.stub!(:load_xml).with(@name).and_return(@doc) #REFACTOR to use .with(Nokogiri::XML::Document, '//document-info//id')
    Book.should_receive(:extract_xml_part).with(@doc, '//document-info//id').once.and_return([]) #REFACTOR to use .with(Nokogiri::XML::Document, '//document-info//id')
    Book.register_working_fb2(@name).should_not be_true
   end
   it "fail on existence of working file with guid" do
    #Book.should_receive(:find_by_fbguid).with('Mon Jun 10 19:57:41 2013').and_return(Factory.build(:book,:fbguid=>'Mon Jun 10 19:57:41 2013'))
    Book.stub!(:find_by_fbguid).with('Mon Jun 10 19:57:41 2013').and_return(Factory(:book,:fbguid=>'Mon Jun 10 19:57:41 2013'))
    Book.register_working_fb2(@name).should_not be_true
   end
   it "check nonexistence of working file with guid" do
    #Book.should_receive(:find_by_fbguid).with('Mon Jun 10 19:57:41 2013').and_return nil
    Book.stub!(:find_by_fbguid).with('Mon Jun 10 19:57:41 2013').and_return(nil)
    
    Book.register_working_fb2(@name).should be_true
   end
   it "extract name from file" do
    Book.stub!(:create).with(:name=>'Белка', :fbguid=>'Mon Jun 10 19:57:41 2013', :file_name=>File.basename(@name)).and_return(Book.new)
    Book.register_working_fb2(@name).should be_true
   end
   it "create valid book" do
    Book.register_working_fb2(@name).should be_true
    Book.count.should == @count + 1
   end
   it "convert name to utf-8 from src encoding"
   it "move file from in to work catalog"
   it "setup file_name"
   after(:each) do
    FileUtils.rm @name
   end
  end
#  it "extract lre_title from file"
#  it "extract lre_annotation from file"
#  it "extract lang from file"
#  it "setup extracted lang"
#  it "extract authors from file"
#  it "ask Author to create authors from extractedlist of hashes"
 end
 describe "state machine" do
  describe "initialy" do
   before(:each) do
    @inited = Factory(:book)
   end
   it "be in created state" do
    @inited.state.should == 'created'
   end
  end

  describe "in state created" do
   before(:each) do
    #@author = Author.make
    #@lang = Lang.make
    `touch test/testdata/work/in.fb2`
    @created = Factory(:book,:state => 'created', :file_name=>'in.fb2')
   end
   subject {@created}
   it "respond to prepare" do
    @created.should be_respond_to(:prepare)
   end
   describe "on prepare" do
    it "test check_book_fields and exec process_media" do
     @created.expects(:check_book_fields).once.returns(true)
     @created.expects(:process_media).once
     @created.prepare.should be_true
    end
    it "should fail on check_book_fields returning false" do
     @created.expects(:check_book_fields).once.returns(false)
     @created.prepare.should_not be_true
    end
    it "should run process_media" do
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
    @prepared = Factory(:book,:state=>'prepared')
   end
   subject { @prepared }
   it "should respond to to_bundled" do
    @prepared.respond_to?(:to_bundled).should be_true
   end
   describe "on to_bundled" do
    it "should run prepare_bundle" do
     @prepared.expects(:prepare_bundle).once
     @prepared.expects(:check_bundled).once.returns(true)
     @prepared.to_bundled
    end
   end
  end

  describe "in bundled state" do
   before(:each) do 
    @bundled = Factory(:book, :state=>'bundled')
   end
   it "respond to publish" do
    assert @bundled.respond_to? :publish
   end
   describe "on publish" do
    it "success when allow_publish? return true" do
     @bundled.expects(:allow_publish?).once.returns(true)
     assert @bundled.publish
    end
    it "fail when allow_publish? return false" do
     @bundled.expects(:allow_publish?).once.returns(false)
     assert !@bundled.publish
    end
   end
  end
 end

 describe "on check_book_fields" do
  before(:each) do
   @annotated = Factory :book, :state => 'created', :file_name=>'in.fb2'
   @unannotated = Factory :book, :state => 'created', :annotation => nil
   @badannotated = Factory :book, :state => 'created', :annotation => '   '
  end
  it "allow valid annotation" do
   assert @annotated.check_book_fields
  end
  it "should not allow blank annotation" do
   @badannotated.check_book_fields.should_not be_true
  end
  it "should allow nil annotation" do
   @unannotated.check_book_fields.should be_true
  end
 end

 describe "on process_media" do
  before(:each) do
   @name = File.join(WORKING_DIR, "#{rand(999)+1}.fb2")
   FileUtils.cp 'test/testdata/24.fb2', @name
   @book = Factory :book, :file_name => File.basename(@name)
  end
  it "should call generate_cover and then generate_testpages" do
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
   @covered = Factory(:book,:file_name => File.basename(@cover))
   @noncovered = Factory(:book, :file_name => File.basename(@noncover))
  end
  it "should raise ErrorNoCover when cover not found in file" do
   assert_raises ErrorNoCover do
    @noncovered.generate_cover
   end
  end
  it "should not raise any when cover exists" do
   assert_nothing_raised do
    @covered.generate_cover
   end
  end
  it "should extract cover and return it" do
   @covered.generate_cover.should be_is_a(Cover)
  end
  after(:each) do
   @noncovered.destroy
   @covered.destroy
   FileUtils.rm @cover
   FileUtils.rm @noncover
  end
 end

 describe "on generate_testpages" do
 end

 describe "on working_file" do
  before do
   @book = Factory(:book)
  end
  it "should return path to fb2 in work dir" do
   @book.working_file.should =~ /^#{WORKING_DIR}/
   #@book.working_file.should =~ /^#{WORKING_DIR.gsub('/', '\/')}/
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
