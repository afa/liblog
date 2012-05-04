xml.instruct! :xml, :version=>"1.0"
xml.rss(:version=>"2.0") do
 xml.channel do
  xml.title("New books at Afa-lib")
  xml.link("http://afalone.ru/lib")
  xml.description("books since last update")
  xml.language('ru-ru')
  @books.each do |book|
   xml.item do
    xml.title(book.name.blank? ? '...' : book.name)
    xml.description("#{book.authors.map(&:name).join ', '} #{book.name}")
    xml.author("Afa")
    xml.pubDate(book.created_at.strftime("%a, %d %b %Y %H:%M:%S %z"))
    xml.link( lib_book_url( book ) )
#    xml.link(post.name ? named_blog_url( post ) :  blog_url( post ) )
    xml.guid( lib_book_url( book ) )
#    xml.guid(post.name ? named_blog_url( post ) :  blog_url( post ) )
   end
  end
 end
end
