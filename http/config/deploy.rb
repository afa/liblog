set :application, "afalone"
#set :repository,  "~/work/ruby/afalone-ru/http/"
set :scm_user, 'afa'
set :scm_password, 'massacre'
set :repository,  "svn+ssh://afahome/data/repo/afalone-ru/http"

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
# set :deploy_to, "/var/www/#{application}"
set :deploy_to, "~/http/#{application}"

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
set :scm, :subversion
set :scm_auth_cache, true
# set :scm, :none
server "afalone-ru.1gb.ru", :app, :web, :db, :primary=>true
#role :app, "afalone-ru.1gb.ru"
#role :web, "afalone-ru.1gb.ru"
#role :db,  "afalone-ru.1gb.ru", :primary => true
set :use_sudo, false
set :user, "w_afalone-ru_3e7b26fa"
set :password, "892638bb"

depend :remote, :gem, "mislav-will_paginate", "2.2.3"
set :deploy_via, :copy
set :copy_strategy, :export
set :copy_exclude, [".svn/*", ".git/*"]

desc "set production params"
task :production, :role=>:all do
 set :deploy_to, '~/'
 set :current_path, 'http'
 server "afalone-ru.1gb.ru", :app, :web, :db, :primary=>true
 set :use_sudo, false
 set :user, "w_afalone-ru_3e7b26fa"
 set :password, "892638bb"
 set :rails_env, 'production'

end

namespace :mongrel do
  set :mongrel_pid, "~/logs_ror/ror_w_afalone-ru_3e7b26fa.pid"
  def get_mongrel_pid
    capture "if [ -f #{mongrel_pid} ] ; then cat #{mongrel_pid}; fi"
  end
 desc 'start mongrel'
 task :start, :roles=>[:app] do
  run "~/init.d/mongrel start #{rails_env}"
 end
 desc 'stop mongrel'
 task :stop, :roles=>[:app] do
  run "~/init.d/mongrel stop #{rails_env}"
 end
 desc 'restart mongrel'
 task :restart, :roles=>[:app] do
  stop
  start
 end
 desc 'mongrel status'
 task :status, :roles=>[:app] do
  pid = get_mongrel_pid
  puts "ok!" if (capture "ps awx|grep #{pid}.*mongrel_rails|grep -v grep") =~ /mongrel/ 
 end
end
