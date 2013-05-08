require "bundler/capistrano"
require 'capistrano/ext/multistage'

server "www.paano.info", :web, :app, :db, primary: true
set :stages, %w(production staging)
set :default_stage, "staging"

set :repo, "paano"
set :deploy_via, :remote_cache
set :use_sudo, false

set :scm, "git"
set :repository, "git@github.com:neilmarion/#{repo}.git"

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

after "deploy", "deploy:cleanup" # keep only the last 5 releases


