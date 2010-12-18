# encoding: UTF-8
#require 'mechanize'
namespace :lre do
 task :t => :environment do
  agent = WWW::Mechanize.new
#  book = Book.first
  #book = Book.find_by_lre_name '10001'
  page = agent.get("http://lib.rus.ec/b/24")
 # page = agent.get("http://lib.rus.ec/b/#{book.lre_name}")
  pp page.links_with :text=>/исправленную/
  #pp page.forms
 end
end
