namespace :puma do
  bundle_wrapper_path = "/home/deployer/.rvm/gems/ruby-2.7.2/wrappers/bundle"

  desc "Start puma"
  task :start do
    on roles(:app) do
      execute "cd #{release_path} && #{bundle_wrapper_path} exec pumactl -P #{shared_path}/tmp/pids/puma.pid start"
    end
  end

  desc "Stop puma"
  task :stop do
    on roles(:app) do
      execute "cd #{release_path} && #{bundle_wrapper_path} exec pumactl -P #{shared_path}/tmp/pids/puma.pid stop"
    end
  end

  desc "Restart puma"
  task :restart do
    on roles(:app) do
      execute "cd #{release_path} && #{bundle_wrapper_path} exec pumactl -P #{shared_path}/tmp/pids/puma.pid stop"

      sudo "service puma restart"
    end
  end
end