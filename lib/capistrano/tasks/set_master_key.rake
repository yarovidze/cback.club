namespace :set do
  task :master_key do
    on roles(:app), in: :sequence, wait: 10 do
      unless test("[ -f #{shared_path}/config/master.key ]")
        upload! 'config/master.key', "#{shared_path}/config/master.key"
      end
    end
  end
end