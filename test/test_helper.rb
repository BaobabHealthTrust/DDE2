ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Add more helper methods to be used by all tests here...
  
  j = 0
  (1..50).collect{|n| n}.shuffle.each do |i|
    id = ("XXX%03d" % i)
    
    Npid.find_by__id((j + 1).to_s).destroy rescue nil
    
    Npid.create(incremental_id: j, national_id: id, site_code: nil, assigned: false)
    
    j += 1
    
  end
  
end
