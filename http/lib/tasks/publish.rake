def unbundle
 # extract from archives in bundle first archive to fb2 (if fb2 empty) and move archive to processed
 unless Dir[File.join 'lre/in/fb2', '*.fb2'].empty?
  puts "fb2 directory is not empty. skip run."
  return
 end
 (Dir[File.join 'lre/in/bundle', '*.rar'] + Dir[File.join 'lre/in/bundle', '*.zip']).each do |f|
  if `file #{f}` =~ /RAR archive data/
   result = `\`which rar\` e -y -inul #{f} \\*.fb2 \\*.fb2.desc lre/in/fb2/`
  elsif `file #{f}` =~ /Zip archive data/
   result = `\`which unzip\` -e #{f} \\*.fb2 \\*.fb2.desc -d lre/in/fb2/`
  end
  puts result
  FileUtils.mv f, 'lre/in/processed', :verbose=>true
 end

 def import_fb2
  #check existence by fbguid then by lre_name
  Dir[File.join('lre/in/fb2', '*.fb2')].each do |name|
   book = Book.find_or_create_by_lre_name :lre_name=>File.basename(name, '.fb2')
   book.parse_fb2(name)
   if book.save
    puts "#{book.id} imported"
    FileUtils.mv_f name, 'lre/in/processed'
   else
    FileUtils.mv_f name, 'lre/invalid'
   end
  end
 end
end

directory 'lre/in/bundle'
directory 'lre/in/fb2'
directory 'lre/in/processed'
directory 'lre/invalid'

namespace :publish do
 desc "extract bundled books"
 task :unbundle => ['lre/in/bundle', 'lre/in/fb2', 'lre/in/processed', :environment] do
  unbundle()
 end

 desc "process extracted fb2 or fb2.desc"
 task :run_fb2 => ['lre/invalid', 'lre/in/fb2', 'lre/in/processed', :environment] do
  import_fb2()
 end
end
