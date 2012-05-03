# coding: UTF-8
namespace :tst do
 task :t => :environment do
  f=Nokogiri::XML.parse File.new('desc/24.fb2.desc')
  f.xpath( '//description' ).each do |p|
   p p
  end
#  f.each do |b|
#   puts b.content
#  end
 end
end
