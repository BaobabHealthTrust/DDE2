# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Rails.application.initialize!

require "bantu_soundex"

# Initialize all views if not initialized

puts "Initializing views"

puts "People count : #{Person.all.count}"

puts "Npids count : #{Npid.all.count}"

puts "Connections count : #{Connection.all.count}"

puts "Footprints count : #{Footprint.all.count}"

puts "RequestsQues count : #{RequestsQue.all.count}"

puts "Sites count : #{Site.all.count}"

puts "Users count : #{User.all.count}"
