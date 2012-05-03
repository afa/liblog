# coding: UTF-8
require 'livejournal'
require "cgi"
def lj_conv_text(txt)
  txt ||= ''
  (CGI.unescape(txt).gsub(/\n/, '<br />').gsub(/<lj\s+(((user=\"(\S+)")|(title="(.+)"))\s*)+\s*>/) { | m | "<span style=\"white-space: nowrap;\"><a href=\"http://users.livejournal.com/#{ $4 }/profile\"><img src=\"/images/lj_user.gif\" alt=\"[info]\" style=\"border: 0pt none; vertical-align: bottom; padding-right: 1px;\" width=\"17px\" height=\"17px\"></a><a href=\"http://users.livejournal.com/#{ $4 }\"><b>#{ $6 || $4 }</b></a></span>" } ) 
end
namespace :lj do

  desc 'Reimport lj posts'
  task :reimport_posts => :environment do
   ljuser = SiteConfig['lj.user']
   ljpass = SiteConfig['lj.password']
   user = SiteConfig['blog.user']
   lastsync = SiteConfig['lj.lastsync'] || '1900-01-01 00:00:00'
   last=DateTime.strptime(lastsync, '%Y-%m-%d %H:%M:%S')
   uid = User.find_by_username user
   (puts "User not found" and return) if uid.nil?
   uid = uid.identity
   iface = XMLRPC::Client.new('www.livejournal.com', '/interface/xmlrpc', 80)
   if Livejournal.lj_login iface, ljuser, ljpass then
    puts "Logged"
    unless (sync = Livejournal.lj_sync iface, ljuser, lastsync).empty?
     unless (items = Livejournal.lj_loaditems iface, ljuser, 'L', sync).empty?
      puts "Load"
      items.each do | i |
       if ImportedEntries.find_by_source_url(i['url'])
        post = ImportedEntries.find_by_source_url(i['url']).andand.blog_post
        post.update_attributes :raw_header=>i['subject'], :raw_text=>i['event'], :created_at=>i['eventtime']
        last = DateTime.strptime(i['eventtime'], '%Y-%m-%d %H:%M:%S') if last < DateTime.strptime(i['eventtime'], '%Y-%m-%d %H:%M:%S') and DateTime.strptime(i['eventtime'], '%Y-%m-%d %H:%M:%S') < DateTime.now
       end
      end
      lastsync = last.strftime('%Y-%m-%d %H:%M:%S')
      puts "Synced upto #{ lastsync }"
      SiteConfig['lj.lastsync']=lastsync
     end
    end
    Livejournal.lj_logout iface
   end
  end

  desc 'Import livejournal posts, changed since last import'
  task :import_posts => :environment do
   ljuser = SiteConfig['lj.user']
   ljpass = SiteConfig['lj.password']
   user = SiteConfig['blog.user']
   lastsync = SiteConfig['lj.lastsync'] || '1900-01-01 00:00:00'
   last=DateTime.strptime(lastsync, '%Y-%m-%d %H:%M:%S')
   uid = User.find_by_username user
   (puts "User not found" and return) if uid.nil?
   uid = uid.identity
   iface = XMLRPC::Client.new('www.livejournal.com', '/interface/xmlrpc', 80)
   if Livejournal.lj_login iface, ljuser, ljpass then
    puts "Logged"
    unless (sync = Livejournal.lj_sync iface, ljuser, lastsync).empty?
     unless (items = Livejournal.lj_loaditems iface, ljuser, 'L', sync).empty?
      puts "Load"
      items.each do | i |
       unless ImportedEntries.find_by_source_url(i['url'])
        post = BlogPost.create :raw_header=>i['subject'], :raw_text=>i['event'], :created_at=>i['eventtime']
#        post = BlogPost.create :title=>lj_conv_text(i['subject']), :raw_text=>lj_conv_text(i['event']), :created_at=>i['eventtime']
        ImportedEntries.create :source_url=>i['url'], :source_created_at=>i['eventtime'], :blog_post_id=>post.id 
        last = DateTime.strptime(i['eventtime'], '%Y-%m-%d %H:%M:%S') if last < DateTime.strptime(i['eventtime'], '%Y-%m-%d %H:%M:%S') and DateTime.strptime(i['eventtime'], '%Y-%m-%d %H:%M:%S') < DateTime.now
       end
      end
      lastsync = last.strftime('%Y-%m-%d %H:%M:%S')
      puts "Synced upto #{ lastsync }"
      SiteConfig['lj.lastsync']=lastsync
     end
    end
    Livejournal.lj_logout iface
   end
  end

  desc 'Import new comments from livejournal'
  task :import_comments do
    puts 'todo comments'
  end
end
