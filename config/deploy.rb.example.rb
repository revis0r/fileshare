# $:.unshift(File.expand_path('./lib', ENV['rvm_path'])) # Add RVM's lib directory to the load path.
require "rvm/capistrano" # Load RVM's capistrano plugin.
require 'bundler/capistrano'
# require 'thinking_sphinx/deploy/capistrano'

require "delayed/recipes"

application_name = 'fileshare'

set :application, application_name
server 'example.com', :web, :app
server 'example.com', :db, :primary => true
set :repository, "git@github.com:revis0r/fileshare.git"

set :rvm_ruby_string, 'ruby-1.9.3-p392'
set :rvm_type, :user
set :rails_env, 'production'

set :deploy_to, "/www/#{application_name}"
set :deploy_via, :remote_cache
set :branch, 'develop'
set :scm, :git
set :scm_verbose, true
set :use_sudo, false
set :db_name_prefix, application.downcase.gsub(/[^a-z]/, '-')
set :unicorn_conf, "#{deploy_to}/current/config/unicorn.rb"
set :unicorn_pid, "#{deploy_to}/shared/unicorn.pid"
set :unicorn_script, "/home/deploy/bin/#{application_name}"
set :rake, "#{rake} --trace"

set :keep_releases, 5

default_run_options[:pty] = true
ssh_options[:paranoid] = false
ssh_options[:user] = "deploy"
ssh_options[:forward_agent] = true
ssh_options[:port] = 22


namespace :deploy do

  desc "Force restart"
  task :restart do
    run "#{unicorn_script} restart"
  end
  
  namespace :unicorn do
    desc "Remove unicron pid file"
    task :cleanup do
      run "rm #{unicorn_pid}"
    end
  end

  desc "Make symlinks"
  task :symlink_configs do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    run "ln -nfs #{shared_path}/config/unicorn.rb #{release_path}/config/unicorn.rb"
    run "ln -nfs #{shared_path}/uploads #{release_path}/public/uploads"
    run "rm -rf #{release_path}/tmp/pids"
  end
  

  task :create_shared_dirs do
    run <<-CMD
    mkdir #{shared_path}/config;
    mkdir #{shared_path}/db;
    CMD
  end
  
  task :create_log_files do
    run "touch #{shared_path}/log/development.log #{shared_path}/log/production.log #{shared_path}/log/test.log"
  end

end

namespace :logs do
  task :watch do
    stream("tail -f #{shared_path}/log/production.log")
  end
end

namespace :bundle do
  task :config do
    run 'export PATH=$PATH:/usr/pgsql-9.2/bin'
  end
end

after "deploy:update_code", "deploy:symlink_configs"
after "deploy:symlink_configs", "delayed_job:stop"
after "deploy:symlink_configs", "deploy:migrate"
load 'deploy/assets'
after "deploy:setup", "deploy:create_log_files"
after  "deploy:restart", "delayed_job:start"
after "deploy:stop",  "delayed_job:stop"
after "deploy:start", "delayed_job:start"
