server "68.183.220.130", user: "#{fetch(:user)}", roles: %w{app db web}, primary: true

set :application, "cback"
set :deploy_to, "/home/#{fetch(:user)}/apps/#{fetch(:application)}"

set :environment, "production"
set :rails_env,   "production"

set :nginx_server_name, "cback.club"
set :puma_conf, "#{shared_path}/config/puma.rb"