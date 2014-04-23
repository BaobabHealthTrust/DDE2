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
    
  # <!----------------------------------- End of group --------------------------/>
  
  
  
  # <!------------------------------ Check return value types ---------------/>
  
  test "check if assign_npids_to_site return result is a boolean" do
    result = Utils::Master.assign_npids_to_site("TST", 10) rescue nil
    
    assert_not_nil(result, "Return value expected to be a boolean")
  end
  
  test "check if add_site return result is a boolean" do    
    Site.find_by__id("TST").destroy rescue nil
    
    result = Utils::Master.add_site("test", "TST") rescue nil
    
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
  
  # <!----------------------------------- End of group --------------------------/>
  
  
  # <!------------------------------ Check results of processing ---------------/>
  
  test "check the effect of assigning ids to a site with assign_npids_to_site" do
  
  end
  
  test "check if site added by add_site" do
    site = "Test"
    site_code = "TST"
    
    Site.find_by__id("TST").destroy rescue nil
    
    Utils::Master.add_site(site, site_code) rescue nil
    
    result = Site.find_by__id(site_code) # rescue nil
    
    assert_not_nil(result, "Failed to create site")
    
  end
  
  # <!-------------------------- End of group ------------------------------/>
  
end
