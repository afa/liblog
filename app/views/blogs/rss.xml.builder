#coding: UTF-8
xml.instruct! :xml, :version=>"1.0" 
xml.rss(:version=>"2.0") do
 xml.channel do
  xml.title("Afalog")
  xml.link("http://afalone.ru/")
  xml.description("Log's & lags")
  xml.language('ru-ru')
  @posts.each do |post|
   xml.item do
    xml.title(post.title.blank? ? '...' : post.title)
    xml.description(post.text)      
    xml.author("Afa")               
    xml.pubDate(post.created_at.strftime("%a, %d %b %Y %H:%M:%S %z"))
    xml.link( blog_url( post ) )
#    xml.link(post.name ? named_blog_url( post ) :  blog_url( post ) )
     xml.guid( blog_url( post ) )
#    xml.guid(post.name ? named_blog_url( post ) :  blog_url( post ) )
   end
  end
 end
end

