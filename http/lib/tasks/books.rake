def l_name(nm)
 n_list = ['.fb2', '.desc', '.invalid']
 name = nm
 0..n_list.size do
  name = n_list.inject(name){|r, n| File.basename r, n}
 end
 name
end
namespace :books do
 task :tst, :files, :needs => :environment do |task_obj, args|
  puts args
 end
 desc "Import book descriptions from fb2"
 task :import, :files, :needs => :environment do |task_name, args|
  require 'rubygems'
  require 'xmlsimple'
#  require 'timeout'
  params = args[:files]
  #params.shift
  exit unless params
  exit if params.empty?
  counter = 5000
  [params].flatten.sort.each do |fname|
   booklist = Book.all.map(&:lre_name).compact
   puts "selecting"
   dir = Dir[fname].select{|n| not booklist.include? l_name(n)}
   puts "select #{dir.size}"
   dir.sort.each do |name|
    next if Book.find_by_lre_name(l_name(name)) and SKIP_EXISTS
    break if counter < 0
    File.open(name, 'r'){ |f|
     puts "#{counter}:#{l_name name}: #{f.stat.size}"
     begin
      puts "xml in"
      begin 
       data = XmlSimple.xml_in f.read 
#       data = Timeout::timeout(300){
#        XmlSimple.xml_in f.read 
#       }
      rescue exception=>e
       puts e.message 
       puts "longly invalid"
       FileUtils.mkdir 'invalid' unless File.directory? 'invalid'
       FileUtils.mv name, 'invalid' if File.directory? 'invalid'
       break
      end
      puts "done."
     rescue
      puts "invalid #{name}"
      FileUtils.mkdir 'invalid' unless File.directory? 'invalid'
      FileUtils.mv name, 'invalid' if File.directory? 'invalid'
      break
     end
     counter -= 1
     data["description"].each do |d|
      d["title-info"].each do |ti|
       unless ti["book-title"]
        puts "invalid #{name}"
        FileUtils.mkdir 'invalid' unless File.directory? 'invalid'
        FileUtils.mv name, 'invalid' if File.directory? 'invalid'
        break
       end
       puts "book-title: #{ ti["book-title"].join '::' }"
       book = Book.find_or_create_by_lre_name :name=>ti["book-title"].join('::'), :lre_name=>l_name(name)
       if ti.has_key? 'author'
       puts "authors: #{ ti["author"].collect{|a| "#{a["first-name"]} #{a["last-name"]}"}.join '; ' }"
       authors = ti["author"].collect {|a| Author.find_or_create_by_first_name_and_last_name :first_name=>a["first-name"].to_s, :last_name=>a["last-name"].to_s }.compact
       else
        authors = []
       end
       unless SKIP_EXISTS
        book.authors.each{ |a| book.authors.delete a }
       end
       authors.each {| a | book.authors << a }
       if ti.has_key? "genre"
        genres = ti["genre"].collect{|g| Genre.find_or_create_by_name :name=>g.to_s }.compact
       else 
        genres = []
       end
       unless SKIP_EXISTS
        book.genres.each{ |g| book.genres.delete g }
       end
       genres.each {| g | book.genres << g }
       puts "genre: #{ genres.map(&:name).join '; ' }"
       if ti.has_key? "lang"
        langs = ti["lang"].collect{|l| Lang.find_or_create_by_name :name=>l.to_s }.compact
       else
        langs = [Lang.find_or_create_by_name :name=>'NoLang']
       end
       unless SKIP_EXISTS and book.lang
        book.lang = langs[0]
       end
       puts "lang: #{langs[0].name}"
       book.save
      end
     end
    }
   end
  end
 end

 desc 'remove "content-match" from genres'
 task :norm_genre => :environment do
  Genre.find( :all, :order=>"name", :conditions=>"name like 'content%match%'" ).each do |genre|
   name = genre.name.match(/content(.+)match/)[1]
   n = Genre.find_or_create_by_name :name=> name
   puts "#{genre.name}(#{genre.books.count}) - #{name}(#{n.books.count})"
   n.join genre
   puts n.books.count
   genre.destroy
  end
 end

 desc "prepare bundles for books(desc only)"
 task :make_desc_bundles => :environment do
#   cb = lang.books.find(:all, :conditions=>'bundle_id is null', :include=>[:authors])
  cb = Book.unbundled.map(&:id)
  puts "books: #{cb.size}"
  until cb.empty?
   bundle=Bundle.create
   bundle.update_attribute :name, bundle.id.to_s
   puts "bundle #{bundle.id}"
   cb[cb.size>=1000 ? -1000 : 0, cb.size > 1000 ? 1000 : cb.size].each do |b|
    bundle.book_ids << b
    puts b
   end
   bundle.save
   cb -= cb[cb.size>1000 ? -1000 : 0, cb.size > 1000 ? 1000 : cb.size]
   puts "saved"
  end

 end

 desc "compress desc bundles"
 task :compress_desc => :environment do
  Bundle.find_each :batch_size=>5 do |bundle|
   str = bundle.books.map{|b| File.join DESC_PATH, "#{b.lre_name}.fb2.desc"}
   puts "compress #{bundle.name}"
   IO.popen( "rar a -inul -m5 -md1024 -s -ep #{File.join BUNDLE_PATH, bundle.name} #{str.join ' '} >/dev/null")
   Process.wait
   puts 'exec done'
   Book.update_all "bundled = 't'", "bundle_id = #{bundle.id}"
   #bundle.books.each{|b| b.update_attribute :bundled, true}
   bundle.update_attribute :is_compressed, true
  end
  puts 'done'
 end

 desc "divide genre"
 task :divide_genre => :environment do
  params = ARGV
  params.shift
  m_name = params.shift
  f_name = params.shift
  s_name = params.shift
  break if f_name.blank?
  m_g = Genre.find_by_name m_name
  break unless m_g
  f_g = Genre.find_or_create_by_name f_name
  s_g = Genre.find_or_create_by_name s_name unless s_name.blank?
  puts "#{m_g.name}(#{m_g.books.size}) #{f_g.name}(#{f_g.books.size}) #{s_g.name if s_g}(#{s_g.books.size if s_g}) "
  m_g.books.each do |b|
   f_g.books << b unless f_g.books.include? b
   s_g.books << b unless s_g.nil? || s_g.books.include?(b)
  end
  f_g.save
  s_g.save unless s_g.nil?
  m_g.books.clear
  puts "#{m_g.name}(#{m_g.books.size}) #{f_g.name}(#{f_g.books.size}) #{s_g.name if s_g}(#{s_g.books.size if s_g}) "
  m_g.save
  m_g.destroy
 end

 desc "join lang"
 task :join_lang => :environment do
  params = ARGV
  params.shift
  m_name = params.shift
  f_name = params.shift
  break if f_name.blank?
  m_g = Lang.find_by_name m_name
  break unless m_g
  f_g = Lang.find_or_create_by_name f_name
  puts "#{m_g.name}(#{m_g.books.size}) #{f_g.name}(#{f_g.books.size}) "
  m_g.books.each do |b|
   f_g.books << b unless f_g.books.include? b
  end
  f_g.save
  m_g.books.clear
  m_g.save
  m_g.destroy
 end
end
