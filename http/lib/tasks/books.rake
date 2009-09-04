
namespace :books do
 desc "Import book descriptions from fb2"
 task :import => :environment do
  require 'rubygems'
  require 'xmlsimple'
  require 'timeout'
  params = ARGV
  params.shift
  exit if params.empty?
  counter = 1000
  params.sort.each do |fname|
   Dir[fname].sort.each do |name|
    next if Book.find_by_lre_name(File.basename(name, '.fb2')) and SKIP_EXISTS
    break if counter < 0
    File.open(name, 'r'){ |f|
     puts "#{counter}:#{File.basename name, '.fb2'}: #{f.stat.size}"
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
       book = Book.find_or_create_by_lre_name :name=>ti["book-title"].join('::'), :lre_name=>File.basename(name, '.fb2')
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
   n = Genre.find_or_create_by_name :name=> name, :include=>[:books]
   puts "#{genre.name}(#{genre.books.count}) - #{name}(#{n.books.count})"
   n.join genre
   puts n.books.count
   genre.destroy
  end
 end
end
