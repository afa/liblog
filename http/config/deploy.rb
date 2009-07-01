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
set :scm_auth_cache, false
# set :scm, :none

role :app, "afalone-ru.1gb.ru"
role :web, "afalone-ru.1gb.ru"
role :db,  "afalone-ru.1gb.ru", :primary => true
set :use_sudo, false
set :user, "w_afalone-ru_3e7b26fa"
set :password, "892638bb"

#depend :remote, :gem, "mislav-will_paginate", "2.2.3"
set :deploy_via, :copy
set :copy_strategy, :export
