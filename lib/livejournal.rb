# coding: UTF-8
require "livejournal"

#=begin
module Livejournal
 require 'net/http'
 require 'xmlrpc/client'
 require 'digest/md5'
 def Livejournal.lj_login( iface, user, pass )
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
 def Livejournal.lj_logout(iface)

 end

 def Livejournal.lj_sync(iface, user, lastsync)
  last = DateTime.strptime(lastsync, '%Y-%m-%d %H:%M:%S') || DateTime.new(1900, 1, 1)
  total, ok, res = 1, true, []
  puts "Start sync since #{ last.strftime('%Y-%m-%d %H:%M:%S') }"
  ok, ans = iface.call2('LJ.XMLRPC.syncitems', {:username=>user, :lastsync => last.strftime('%Y-%m-%d %H:%M:%S'), :auth_method=>'cookie', :ver=>'1'})
  if ok then
    ans['syncitems'].each do | i |
      res << i
    end
  end
  res
 end
 def Livejournal.lj_loaditems(iface, user, t, to_load)
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
end
#=end
