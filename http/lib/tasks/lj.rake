require 'net/http'
require 'xmlrpc/client'
require 'digest/md5'
require "cgi"
def lj_login( iface, user, pass )
  ok, ans = iface.call2('LJ.XMLRPC.getchallenge')
  if ok then
    ok, ans = iface.call2('LJ.XMLRPC.sessiongenerate', { :username=>user, :ver=>0, :auth_scheme=>ans['auth_scheme'], :auth_challenge=>ans['challenge'], :auth_response=>Digest::MD5.hexdigest( ans['challenge'] + Digest::MD5.hexdigest(pass) ), :auth_method=>'challenge', :expiration=>'short' })
    if ok then # logged in
      iface.http_header_extra = {"X-LJ-Auth" => "cookie", "Cookie" => "ljsession=#{ ans['ljsession'] }"}
    else
      puts 'Error logging in'
      return false
    end
  else
    puts 'Session request error'
    return false
  end
  return true
end

def lj_logout(iface)

end

def lj_sync(iface, user, lastsync)
  last = DateTime.strptime(lastsync, '%Y-%m-%d %H:%M:%S') || DateTime.new(1900, 1, 1)
  total, ok, res = 1, true, []
  puts "Start sync since #{ last.strftime('%Y-%m-%d %H:%M:%S') }"
  while ok and total > 0 do
    ok, ans = iface.call2('LJ.XMLRPC.syncitems', {:username=>user, :lastsync => last.strftime('%Y-%m-%d %H:%M:%S'), :auth_method=>'cookie', :ver=>'1'})
    if ok then
      total = ans['total']
      ans['syncitems'].each do | i |
        res << i
        if DateTime.strptime(i['time'], '%Y-%m-%d %H:%M:%S') > last then
          last = DateTime.strptime(i['time'], '%Y-%m-%d %H:%M:%S')
        end
      end
    end
  end
  res
end

def lj_loaditems(iface, user, t, to_load)
  ok, res, last, ans = true, [], DateTime.new(1900, 1, 1), {'events'=>[{}]}
  to_load.each do | i |
    if (m = /^#{t}-(\d+)$/.match i['item']) then
      putc '.'
      ok, ans = iface.call2('LJ.XMLRPC.getevents', { :username=>user, :auth_method=>'cookie', :ver=>1, :selecttype=>'one', :itemid=>m.captures[0], :lineendings=>'unix' })
      if ok then
        res << ans['events'][0]
      end
    end
  end
  puts "[#{res.length}]"
  res
end
def lj_conv_text(txt)
  txt ||= ''
  (CGI.unescape(txt).gsub(/\n/, '<br />').gsub(/<lj\s+(((user=\"(\S+)")|(title="(.+)"))\s*)+\s*>/) { | m | "<span style=\"white-space: nowrap;\"><a href=\"http://users.livejournal.com/#{ $4 }/profile\"><img src=\"/images/lj_user.gif\" alt=\"[info]\" style=\"border: 0pt none; vertical-align: bottom; padding-right: 1px;\" width=\"17px\" height=\"17px\"></a><a href=\"http://users.livejournal.com/#{ $4 }\"><b>#{ $6 || $4 }</b></a></span>" } ) 
end
namespace :lj do
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
    if lj_login iface, ljuser, ljpass then
      puts "Logged"
      if (sync = lj_sync iface, ljuser, lastsync).length >0 then
        if (items = lj_loaditems iface, ljuser, 'L', sync).length > 0 then
          puts "Load"
          items.each do | i |
            if ImportedEntries.find_by_source_url(i['url']).nil? then
              post = BlogPost.create :title=>lj_conv_text(i['subject']), :text=>lj_conv_text(i['event']), :created_at=>i['eventtime']
              ImportedEntries.create :source_url=>i['url'], :source_created_at=>i['eventtime'], :blog_post_id=>post.id 
              last = DateTime.strptime(i['eventtime'], '%Y-%m-%d %H:%M:%S') if last < DateTime.strptime(i['eventtime'], '%Y-%m-%d %H:%M:%S') and DateTime.strptime(i['eventtime'], '%Y-%m-%d %H:%M:%S') < DateTime.now
            end
          end
          lastsync = last.strftime('%Y-%m-%d %H:%M:%S')
          puts "Synced upto #{ lastsync }"
          SiteConfig['lj.lastsync']=lastsync
        end
      end
      lj_logout iface
    end
  end
  desc 'Import new comments from livejournal'
  task :import_comments do
    puts 'todo comments'
  end
end
