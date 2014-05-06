	# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
user = User.find('admin')
if user.blank?
	user = User.new()
	user.username = "admin"
	user.password_hash = "password"
	user.first_name = "DDE"
	user.last_name = "Administrator"
	user.role = "admin"
	user.site_code = Site.current_code
	user.email = "admin@baobabhealth.org"
	user.save
  puts "User created succesfully!"
else
  puts "User already exists"
end

