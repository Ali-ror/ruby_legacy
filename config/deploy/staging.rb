set :application, 'relylocal'
set :hostname, 'relylocaldev.aghosted.com'
set :rails_env,'production'
ssh_options[:paranoid] = false
set :use_sudo, false

role :app, hostname
role :web, hostname
role :db,  hostname, :primary => true

# rvm environment variables
set :default_environment, {
  'PATH' => "/usr/local/rvm/gems/ruby-1.9.2-p0/bin:/usr/local/rvm/gems/ruby-1.9.2-p0@global/bin:/usr/local/rvm/rubies/ruby-1.9.2-p0/bin:$PATH",
  'RUBY_VERSION' => 'ruby 1.9.2',
  'GEM_HOME'     => '/usr/local/rvm/gems/ruby-1.9.2-p0',
  'GEM_PATH'     => '/usr/local/rvm/gems/ruby-1.9.2-p0:/usr/local/rvm/gems/ruby-1.9.2-p0@global',
  'BUNDLE_PATH'  => '/usr/local/rvm/gems/ruby-1.9.2-p0'  # If you are using bundler.
}

# User/pass.  The username is used for passwordless SSH (get yer keys setup, 
# eh?), and the u/p are used for DB and svn checkout access on the remote 
# servers.
set :user, 'deploy'

set :deploy_to, " /var/www/apps/#{application}/#{rails_env}/"
default_run_options[:pty] = true
ssh_options[:forward_agent] = true
set :repository, "git@github.com:agathongroup/relylocal.git"
set :scm, "git"
set :deploy_via, :remote_cache
set :git_shallow_clone, 1
set :scm_verbose, true
set :branch, 'develop'
