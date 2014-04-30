require 'test_helper'

class MasterTest < ActiveSupport::TestCase    
  include Utils
    
  # <!--------------------- Check for input parameters in this group ------------------------/>
   
  test "check if assign_npids_to_site first argument is not blank" do
    
    exception = assert_raises(RuntimeError) {
      Utils::Master.assign_npids_to_site(nil, 10) 
    }
    
    assert_equal("First argument cannot be blank", exception.message)
  end 
  
  test "check if assign_npids_to_site second argument is not blank" do
    
    exception = assert_raises(RuntimeError) {
      Utils::Master.assign_npids_to_site("test", nil) 
    }
    
    assert_equal("Second argument is supposed to be an integer", exception.message)
  end 
    
  # add_site
  test "check if add_site first argument is not blank" do
    
    exception = assert_raises(RuntimeError) {
      Utils::Master.add_site(nil, "test", "test", 1) 
    }
    
    assert_equal("First argument cannot be blank", exception.message)
  end 
  
  test "check if add_site second argument is not blank" do
    
    exception = assert_raises(RuntimeError) {
      Utils::Master.add_site("test", nil, "test", 1) 
    }
    
    assert_equal("Second argument cannot be blank", exception.message)
  end 
  
  test "check if add_site third argument is not blank" do
    
    exception = assert_raises(RuntimeError) {
      Utils::Master.add_site("test", "test", nil, 1) 
    }
    
    assert_equal("Third argument cannot be blank", exception.message)
  end 
  
  test "check if add_site fourth argument is an integer" do
    
    exception = assert_raises(RuntimeError) {
      Utils::Master.add_site("test", "test", "test", nil) 
    }
    
    assert_equal("Fourth argument can only be a number", exception.message)
  end 
  
  # que_site
  test "check if que_site first argument is not blank" do
    
    exception = assert_raises(RuntimeError) {
      Utils::Master.que_site(nil, "test", 1, "test") 
    }
    
    assert_equal("First argument cannot be blank", exception.message)
  end 
  
  test "check if que_site second argument is not blank" do
    
    exception = assert_raises(RuntimeError) {
      Utils::Master.que_site("test", nil, 1, "test") 
    }
    
    assert_equal("Second argument cannot be blank", exception.message)
  end 
  
  test "check if que_site third argument is not blank" do
    
    exception = assert_raises(RuntimeError) {
      Utils::Master.que_site("test", "test", nil, "test") 
    }
    
    assert_equal("Third argument can only be an integer", exception.message)
  end 
  
  test "check if que_site fourth argument is not blank" do
    
    exception = assert_raises(RuntimeError) {
      Utils::Master.que_site("test", "test", 1, nil) 
    }
    
    assert_equal("Fourth argument cannot be blank", exception.message)
  end 
  
  # assign_npids_to_region
  
  test "check if assign_npids_to_region first argument is not blank" do
    
    exception = assert_raises(RuntimeError) {
      Utils::Master.assign_npids_to_region(nil, 10) 
    }
    
    assert_equal("First argument cannot be blank", exception.message)
  end 
  
  test "check if assign_npids_to_region second argument is not blank" do
    
    exception = assert_raises(RuntimeError) {
      Utils::Master.assign_npids_to_region("test", nil) 
    }
    
    assert_equal("Second argument is supposed to be an integer", exception.message)
  end 
    
  # <!----------------------------------- End of group --------------------------/>
  
  
  
  # <!------------------------------ Check return value types ---------------/>
  
  test "check if assign_npids_to_site return result is a boolean" do
    result = Utils::Master.assign_npids_to_site("TST", 1) rescue nil
    
    assert_not_nil(result, "Return value expected to be a boolean")
  end
  
  test "check if add_site return result is a boolean" do    
    Site.find_by__id("TST").destroy rescue nil
    
    result = Utils::Master.add_site("test", "TST", "Centre", 10) rescue nil
    
    assert_not_nil(result, "Return value expected to be a boolean")
  end
  
  test "check if get_unassigned_npids return result is an array" do
    result = Utils::Master.get_unassigned_npids() rescue nil
    
    assert_kind_of(Array, result, "Return value expected to be an array")
  end

  test "check if get_all_sites return result is an array" do
    result = Utils::Master.get_all_sites() rescue nil
    
    assert_kind_of(Array, result, "Return value expected to be an array")
  end
  
  test "check if que_site return result is a boolean" do
    result = Utils::Master.que_site("test", "TST", 10, "Centre") rescue nil
    
    assert_kind_of(TrueClass, result, "Return value expected to be a boolean")
  end
  
  test "check if assign_npids_to_region return result is a boolean" do
    result = Utils::Master.assign_npids_to_region("Centre", 100) rescue nil
    
    assert_not_nil(result, "Return value expected to be a boolean")
  end
  
  test "check if check_site_thresholds return result is a boolean" do
    result = Utils::Master.check_site_thresholds() rescue nil
    
    assert_not_nil(result, "Return value expected to be a boolean")
  end
  
  test "check if process_queued_sites return result is a boolean" do
    result = Utils::Master.process_queued_sites() rescue nil
    
    assert_not_nil(result, "Return value expected to be a boolean")
  end
  
  # <!----------------------------------- End of group --------------------------/>
  
  
  # <!------------------------------ Check results of processing ---------------/>
  
  test "check the effect of assigning ids to a site with assign_npids_to_site" do
    Utils::Master.assign_npids_to_region("Centre", 20)
    
    startcount = Npid.unassigned_to_site.count
    
    result = Utils::Master.assign_npids_to_site("TST", 10)
    
    endcount = Npid.unassigned_to_site.count
    
    assert_equal((startcount - endcount), 10 )
    
  end
  
  test "check if site added by add_site" do
    site = "Test"
    site_code = "TST"
    
    Site.find_by__id("TST").destroy rescue nil
    
    Utils::Master.add_site(site, site_code, "Centre", 50) rescue nil
    
    result = Site.find_by__id(site_code) # rescue nil
    
    assert_not_nil(result, "Failed to create site")
    
  end
  
  test "check the effect of assigning ids to a region with assign_npids_to_region" do
    
    startcount = Npid.unassigned_to_region.count
    
    result = Utils::Master.assign_npids_to_region("Centre", 1)
    
    endcount = Npid.unassigned_to_region.count
    
    assert_equal((startcount - endcount), 1 )
    
  end
  
  # <!-------------------------- End of group ------------------------------/>
  
end
