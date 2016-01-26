namespace :dde do
  desc "Creating default user"
  task setup: :environment do
    require Rails.root.join('db','seeds.rb')
  end

  desc "Creating local proxy"
  task install_local: :environment do
    require Rails.root.join('db','local_install.rb')
  end

end
