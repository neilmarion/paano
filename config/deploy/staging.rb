set :user, "deployer"
set :branch, "staging"
set :application, "paanouplb_staging"
set :deploy_to, "/home/#{user}/apps/#{application}"

set :rails_env, "staging"

namespace :deploy do
  %w[start stop restart].each do |command|
    desc "restarting nginx"
    task command, roles: :app, except: {no_release: true} do
      sudo "service nginx restart"
    end 
  end 

  task :setup_config, roles: :app do
    #sudo "ln -nfs #{current_path}/config/nginx.conf /etc/nginx/sites-enabled/#{application}"
    #sudo "ln -nfs #{current_path}/config/unicorn_init_staging.sh /etc/init.d/unicorn_#{application}"
    run "mkdir -p #{shared_path}/config"
    put File.read("config/database.example.yml"), "#{shared_path}/config/database.yml"
    puts "Now edit the config files in #{shared_path}."
  end 
  after "deploy:setup", "deploy:setup_config"

  task :symlink_config, roles: :app do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end 
  after "deploy:finalize_update", "deploy:symlink_config"

  desc "Make sure local git is in sync with remote."
  task :check_revision, roles: :web do
    unless `git rev-parse HEAD` == `git rev-parse origin/staging`
      puts "WARNING: HEAD is not the same as origin/staging"
      puts "Run `git push` to sync changes."
      exit
    end 
  end 
  before "deploy", "deploy:check_revision"
end
