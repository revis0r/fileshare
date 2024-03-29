deploy_to  = "/www/fileshare"
rails_root = "#{deploy_to}/current"
pid_file   = "#{deploy_to}/shared/unicorn.pid"
socket_file= "#{deploy_to}/shared/unicorn.sock"
log_file   = "#{rails_root}/log/unicorn.log"
err_log    = "#{rails_root}/log/unicorn_error.log"
old_pid    = pid_file + '.oldbin'

timeout 240
worker_processes 4
listen socket_file, :backlog => 1024
pid pid_file
stderr_path err_log
stdout_path log_file

preload_app true

before_exec do |server|
  ENV[BUNDLE_GEMFILE] = "#{rails_root}/Gemfile"
end

before_fork do |server, worker|
  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.connection.disconnect!
      
  # 0-time deploy-related magic. Dont't touch!
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill(QUIT, File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # someone else did our job for us
    end
  end
end

after_fork do |server, worker|
  # When created, worker connects to the base
    defined?(ActiveRecord::Base) and
        ActiveRecord::Base.establish_connection
end