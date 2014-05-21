require 'xmlrpc/client'
module Import
  module Pull
    module Livejournal
      extend self
      def lj_login(user, pass, &block)
        iface = XMLRPC::Client.new('www.livejournal.com', '/interface/xmlrpc', 80)
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
    end
  end
end
