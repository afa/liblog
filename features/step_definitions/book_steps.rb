Given /^I am with new fb2 file$/ do
 @src_new_file = 'test/testdata/24.fb2'
 File.should be_exist(@src_new_file)
end

Given /^file not registered in db$/ do
 Book.find_by_file_name(File.basename(@src_new_file)).should be_nil
end

When /^I place fb2 in input catalog$/ do
 `cp #{@src_new_file} #{BATCH_INPUT_DIR}`
 @new_file = Dir[File.join(BATCH_INPUT_DIR, '*.fb2')].first
 @new_file.should_not be_nil
end

When /^start register script$/ do
 Book.register_working_fb2(@new_file).should be_true
end

Then /^book must be created in db$/ do
 Book.find_by_file_name(File.basename(@new_file)).should be_kind_of(Book)
end

Then /^book fields should be loaded from file$/ do
 book = Book.find_by_file_name(File.basename(@new_file))
 book.should_not be_nil
 book.name.should_not be_blank
 book.file_name.should == File.basename(@new_file)
 book.state.should == 'created'
 book.fbguid.should_not be_blank
end

Then /^book must have unique fbguid$/ do
 book = Book.find_by_file_name(File.basename(@new_file))
 Book.count(:conditions=>{:fbguid=>book.fbguid}).should == 1
end

