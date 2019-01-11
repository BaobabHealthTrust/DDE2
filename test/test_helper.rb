ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Add more helper methods to be used by all tests here...
  
  if Npid.unassigned_to_site.count < 100
    j = 1
    (1..500).collect{|n| n}.shuffle.each do |i|
      id = NationalPatientId.new(i).to_s.gsub(/\-/, "")    # ("XX%04d" % i)
      
      Npid.find_by__id((j + 1).to_s).destroy rescue nil
      
      Npid.create(incremental_id: j, national_id: id, site_code: "", assigned: false) rescue nil
      
      j += 1
      
    end
  end
  
end
