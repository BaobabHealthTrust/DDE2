ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Add more helper methods to be used by all tests here...
  
  if Npid.unassigned_to_site.count < 100
    j = 0
    (1..1000).collect{|n| n}.shuffle.each do |i|
      id = ("XX%04d" % i)
      
      Npid.find_by__id((j + 1).to_s).destroy rescue nil
      
      Npid.create(incremental_id: j, national_id: id, site_code: "", assigned: false)
      
      j += 1
      
    end
  end
  
end
