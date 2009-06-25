set :application, "http"
set :repository,  "~/work/ruby/afalone-ru/http/"
#set :repository,  "svn+ssh://afa@afahome/"

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
# set :deploy_to, "/var/www/#{application}"
set :deploy_to, "~/#{application}"

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
# set :scm, :subversion
set :scm, :none

role :app, "192.168.224.43"
role :web, "192.168.224.43"
role :db,  "192.168.224.43", :primary => true



depend :remote, :gem, "mislav-will_paginate", ""
set :deploy_via, :copy
set :copy_strategy, :export
