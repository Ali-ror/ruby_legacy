set :application, 'relylocal'
set :hostname, 'relylocal.aghosted.com'
set :rails_env,'production'
ssh_options[:paranoid] = false
set :use_sudo, false

role :app, hostname
role :web, hostname
role :db,  hostname, :primary => true

# User/pass.  The username is used for passwordless SSH (get yer keys setup, 
# eh?), and the u/p are used for DB and svn checkout access on the remote 
# servers.
set :user, 'appserver'

set :deploy_to, " /var/www/apps/#{application}/#{rails_env}/"
default_run_options[:pty] = true
ssh_options[:forward_agent] = true
set :repository, "git@github.com:agathongroup/relylocal.git"
set :scm, "git"
set :deploy_via, :copy
set :git_shallow_clone, 1
set :scm_verbose, true
set :branch, 'master'
