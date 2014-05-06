namespace :dde do
  desc "Creating default user"
  puts "creating default user"
  task setup: :environment do
    require Rails.root.join('db','seeds.rb')
  end

end
