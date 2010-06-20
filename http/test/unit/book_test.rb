require 'test_helper'
#require 'fakefs'

class BookTest < ActiveSupport::TestCase
 context "book" do
  setup do
   @book = Book.make
  end
  subject {@book}
  context "class" do
   should "has method per_page with default value 30" do
    assert Book.respond_to? :per_page
    assert_equal Book.per_page, 30
   end
   should "register working fb2 from file" do
    assert Book.respond_to? :register_working_fb2
   end
   context "on register_working_fb2" do
    should "check existence of in file"
    should "extract fb_guid from file"
    should "check nonexistence of working file by guid"
   end
  end
  context "state machine" do
   context "initialy" do
    setup do
     @inited = Book.make
    end
    should "be in created state" do
     assert_equal @inited.state, 'created'
     assert_equal @inited.state_name, :created
    end
   end
   context "in state created" do
    setup do
     #@author = Author.make
     #@lang = Lang.make
     @created = Book.make :state => 'created'
     @unannotated = Book.make :state => 'created', :annotation => nil
     @badannotated = Book.make :state => 'created', :annotation => '   '
    end
    subject {@created}
    should "respond to prepare" do
     assert @created.respond_to? :prepare
    end
    should "not allow blank annotation" do
     assert !@badannotated.check_book_fields
    end
    should "allow nil annotation" do
     assert @unannotated.check_book_fields
    end
    context "on prepare" do
     should "test check_book_fields" do
      @created.expects(:check_book_fields).once.returns(true)
      assert @created.prepare
     end
     should "fail on check_book_fields returning false" do
      @created.expects(:check_book_fields).once.returns(false)
      assert !@created.prepare
     end
     should "check for annotation" do
      assert @created.prepare
      assert !@badannotated.prepare
     end
     should "run process_media" do
      @created.expects(:process_media)
      @created.prepare
     end
    end
   end
   context "in prepared state" do
    setup do
     @prepared = Book.make :state=>'prepared'
    end
    subject { @prepared }
    should "respond to to_bundled" do
     assert @prepared.respond_to? :to_bundled
    end
    context "on to_bundled" do
     should "run prepare_bundle" do
      @prepared.expects(:prepare_bundle).once
      @prepared.expects(:check_bundled).once.returns(true)
      @prepared.to_bundled
     end
    end
   end
   context "in bundled state" do
    setup do 
     @bundled = Book.make(:state=>'bundled')
    end
    should "respond to publish" do
     assert @bundled.respond_to? :publish
    end
    context "on publish" do
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
  should have_many :covers
  should have_and_belong_to_many :authors
  should have_and_belong_to_many :genres
  should belong_to :lang
  should belong_to :bundle
  should validate_uniqueness_of :fbguid
  should validate_presence_of :name
 end
end



