require 'mechanize'
namespace :lre do
 task :t => :environment do
  agent = WWW::Mechanize.new
  book = Book.first
  page = agent.get("http://lib.rus.ec/b/#{book.lre_name}")
  pp page.links
  pp page.forms
 end
end
