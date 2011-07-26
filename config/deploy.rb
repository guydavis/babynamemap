set :application, "baby"
set :user, "root"
set :mongrel_user, "mongrel"
set :mongrel_group, "mongrel"
set :mongrel_port, 6000
set :mongrel_servers, 3

set :repository,  "http://www.guydavis.ca/svn/home/web/baby"
set :deploy_to, "/var/www/#{application}"
set :domain, "#{user}@babynamemap.com"

namespace :vlad do
  remote_task :update do
    run "chown -R #{mongrel_user}.#{mongrel_group} #{deploy_to}/current/tmp"
    run "chown #{mongrel_user}.#{mongrel_group} #{deploy_to}/current/public"
  end
end
