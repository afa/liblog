#coding: UTF-8
xml.instruct! :xml, :version=>"1.0"
xml.urlset(:xmlns => "http://www.sitemaps.org/schemas/sitemap/0.9") do
 xml.url do
  xml.loc(blogs_url)
  lastmod = @messages[0].created_at.strftime("%Y-%m-%d") if !@messages.nil?
  lastmod = lastmod || Time.now.strftime("%Y-%m-%d")
  xml.lastmod(lastmod)
  xml.changefreq("daily")
  xml.priority(1)
 end
 @messages.each do |message|
  xml.url do
   xml.loc(blog_url( message.id ))
   xml.lastmod(message.created_at.strftime("%Y-%m-%d"))
   xml.changefreq("weekly")
   xml.priority(0.8)
  end
 end
end

