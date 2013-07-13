require 'bundler/capistrano'
require 'resque'

set :stages, %w(production testing)
set :default_stage, "testing"
require 'capistrano/ext/multistage'

set :whenever_command, 'bundle exec whenever'
require 'whenever/capistrano'

set :application, "osharek"
set :repository,  "git@dev.osharek.com:osharek2.git"
set :user, "git"
set :use_sudo, false
set :deploy_to, "/var/www/#{application}"


# role :db,  "your slave db-server here"

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
  
  task :precompile_assets do
    run "cd #{release_path}; bundle exec rake RAILS_ENV=#{rails_env} assets:precompile"
  end

  task :symlinks, :roles => :app do
    run "#{try_sudo} ln -nfs #{shared_path}/solr #{release_path}/solr/data"
  end
  after 'deploy:update_code', 'deploy:precompile_assets', 'deploy:symlinks'
end

namespace :setup do
  task :solr do
    run "#{try_sudo} mkdir -p #{shared_path}/solr/"
    
    run "#{try_sudo} chmod g+w #{shared_path}/solr/"
  end
  after 'deploy:setup', 'setup:solr'
end

namespace :resque do
  desc "Start resque processes"
  task :start do
    run "/sbin/start-stop-daemon -S -b -m -p #{current_path}/tmp/pids/resqued.pid -d #{current_path} -a `which bundle` -- exec rake resque:work QUEUE='*' RAILS_ENV=#{rails_env}"
  end
  
  desc "Stop resque processes"
  task :stop do
    run "if [ -f #{current_path}/tmp/pids/resqued.pid ]; then cat #{current_path}/tmp/pids/resqued.pid | xargs kill && rm #{current_path}/tmp/pids/resqued.pid; fi"
  end
  
  desc "Restart resque processes"
  task :restart do
    stop
    start
  end
  
  %w[start stop restart].each do |command|
    after "deploy:#{command}", "resque:#{command}"
  end
end

namespace :nodejs do
  desc "Start Node Application"
  task :start do
    run "/sbin/start-stop-daemon -S -b -m -p #{current_path}/tmp/pids/nodejsd.pid -d #{release_path}/node -a `which node` app.js"
  end
  
  desc "Stop Node Application"
  task :stop do
    run "/sbin/start-stop-daemon -K -p #{current_path}/tmp/pids/nodejsd.pid -d #{release_path}/node -a `which node` app.js"
  end

  desc "install any node dependencies"
  task :npm_install do 
    run "cd #{release_path}/node && npm install"
  end
  
  desc "Create symbolic link for node_modules"
  task :symlinks do
    run "#{try_sudo} rm -fr #{release_path}/node/node_modules && #{try_sudo} ln -nfs #{shared_path}/node_modules #{release_path}/node/node_modules"
  end
  
  desc "Create shared directory for node_modules"
  task :setup do
    run "#{try_sudo} mkdir -p #{shared_path}/node_modules"
  end
  
  desc "Restart Node Application"
  task :restart do
    stop
    start
  end
  %w[start stop restart setup].each do |command|
    after "deploy:#{command}", "nodejs:#{command}"
  end
  after 'deploy:update_code', 'nodejs:symlinks', 'nodejs:npm_install'
end
