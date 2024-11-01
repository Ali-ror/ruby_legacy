# Capistrano multi-stage
set :stages, %w(production staging)
require 'capistrano/ext/multistage'
require File.join(File.dirname(__FILE__), 'deploy', 'version')

# Bundler support
require 'bundler/capistrano'

# rvm environment variables
set :default_environment, {
  'PATH' => "/usr/local/rvm/gems/ruby-1.9.2-p136/bin:/usr/local/rvm/gems/ruby-1.9.2-p136@global/bin:/usr/local/rvm/rubies/ruby-1.9.2-p136/bin:$PATH",
  'RUBY_VERSION' => 'ruby 1.9.2',
  'GEM_HOME'     => '/usr/local/rvm/gems/ruby-1.9.2-p136',
  'GEM_PATH'     => '/usr/local/rvm/gems/ruby-1.9.2-p136:/usr/local/rvm/gems/ruby-1.9.2-p136@global',
  'BUNDLE_PATH'  => '/usr/local/rvm/gems/ruby-1.9.2-p136'  # If you are using bundler.
}

set :repository, "git@github.com:agathongroup/relylocal.git"
set :deploy_via, :remote_cache

# After we deploy, we should clean up after oursleves to avoid leaving a ton
# of old releases lying around
after "deploy", "deploy:cleanup"
after "deploy:migrations", "deploy:cleanup"

# lifted from http://tnux.net/2008/06/23/capistrano-and-passenger/
namespace :deploy do
  desc "Restarting mod_rails with restart.txt"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt"
  end

  desc "Stop task is a deploy.web.disable with mod_rails"
  task :stop, :roles => :app do
    deploy.web.disable
  end

  desc "Start task is a deploy.web.enable with mod_rails"
  task :start, :roles => :app do
    deploy.web.enable
  end
end

after 'deploy:update_code', :roles => :app do
  %w{uploads}.each do |share|
    run "rm -rf #{release_path}/public/#{share}"
    run "mkdir -p #{shared_path}/system/#{share}"
    run "ln -nfs #{shared_path}/system/#{share} #{release_path}/public/#{share}"
  end
  run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
end
