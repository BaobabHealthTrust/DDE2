# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Rails.application.initialize!

require "bantu_soundex"

# Initialize all views if not initialized

puts Person.all.count

puts Npid.all.count

puts Connection.all.count

puts Footprint.all.count

puts RequestsQue.all.count

puts Site.all.count

puts User.all.count
