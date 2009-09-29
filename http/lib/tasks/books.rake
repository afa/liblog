n_list = ['.fb2', '.desc', '.invalid']
def l_name(nm)
 name = nm
 0..n_list.size do
  name = n_list.inject(name){|r, n| File.basename r, n}
 end
 name
end
namespace :books do
 desc "Import book descriptions from fb2"
 task :import => :environment do
  require 'rubygems'
  require 'xmlsimple'
  require 'timeout'
  params = ARGV
  params.shift
  exit if params.empty?
  counter = 5000
  params.sort.each do |fname|
   Dir[fname].sort.each do |name|
    next if Book.find_by_lre_name(l_name(name)) and SKIP_EXISTS
    break if counter < 0
    File.open(name, 'r'){ |f|
     puts "#{counter}:#{l_name name}: #{f.stat.size}"
     begin
      puts "xml in"
      begin 
       data = Timeout::timeout(300){
        XmlSimple.xml_in f.read 
       }
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
  cb = Book.unbundled
  blk = []
  puts 'scan'
  while cb.size > 0
   b = [cb[0]]
   a = []
   p_cnt = 0
   cnt = 1
   while p_cnt < cnt
    p_cnt = a.size + b.size
    a += (b.compact.map(&:authors).flatten.compact.uniq) - a
    b += (a.compact.map(&:books).flatten.compact.uniq) - b
    cb -= b
    cnt = a.size + b.size
   end
   b.compact!
   b.uniq!
   blk << b.map(&:id)
   cb -= b
   puts "#{b.size} #{a.compact.uniq.size} #{cb.compact.size}"
  end
  blk.sort!{|a, b| a.size <=> b.size}
  blk.reverse!
  puts "bundles #{blk.size} #{blk.flatten.size} #{blk[0].size}"
  puts "creating (#{blk.size})"
  while blk.size > 0
   puts blk.size
   books = blk.delete_at 0
   while books.size >1000
    bks = books[0..999]
    books -= bks
    bnd = Bundle.create
    bnd.update_attribute :name, bnd.id.to_s
    bks.map{|i| Book.find i }.each{|book| bnd.books << book }
    bnd.save
   end
   bnd = Bundle.create
   bnd.update_attribute :name, bnd.id.to_s
   while bnd.books.size < 1000
    bks = blk.detect{|b| (bnd.books.size + b.size) <= 1000 }
    break unless bks
    blk.delete bks
    bks.map{|i| Book.find i }.each{|b| bnd.books << b }
   end
   bnd.save
  end
 end

 desc "compress desc bundles"
 task :compress_desc => :environment do
  Bundle.find_each :batch_size=>5, :include=>[:books] do |bundle|
   str = bundle.books.map{|b| File.join DESC_PATH, "#{b.lre_name}.fb2.desc"}
   puts "compress #{bundle.name}"
   IO.popen "rar a -m5 -md1024 -s -ep #{File.join BUNDLE_PATH, bundle.name} #{str.join ' '}"
   Process.wait
   bundle.books.each{|b| b.update_attribute :bundled, true}
   bundle.update_attribute :is_compressed, true
  end
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