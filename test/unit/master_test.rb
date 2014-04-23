require 'test_helper'

class UtilsMaster
  include Utils
end

class UtilsMasterTest < ActiveSupport::TestCase
    
  # <!--------------------- Check for input parameters in this group ------------------------/>
   
  test "check if assign_npids_to_site first argument is not blank" do
    
    exception = assert_raises(RuntimeError) {
      UtilsMaster::Master.assign_npids_to_site(nil, 10) 
    }
    
    assert_equal("First argument cannot be blank", exception.message)
  end 
    
  test "check if assign_npids_to_site second argument is not blank" do
    
    exception = assert_raises(RuntimeError) {
      UtilsMaster::Master.assign_npids_to_site("test", nil) 
    }
    
    assert_equal("Second argument is supposed to be an integer", exception.message)
  end 
    
  # <!----------------------------------- End of group --------------------------/>
  
  
  
  # <!------------------------------ Check return value types ---------------/>
  
  test "check if assign_npids_to_site return result is a boolean" do
    result = UtilsMaster::Master.assign_npids_to_site("test", 10) rescue nil
    
    assert_not_nil(result, "Return value expected to be a boolean")
  end
  
  test "check if add_site return result is a boolean" do
    result = UtilsMaster::Master.add_site("test", "test") rescue nil
    
    assert_not_nil(result, "Return value expected to be a boolean")
  end
  
  test "check if get_unassigned_npids return result is an array" do
    result = UtilsMaster::Master.get_unassigned_npids() rescue nil
    
    assert_kind_of(Array, result, "Return value expected to be an array")
  end

  test "check if get_all_sites return result is an array" do
    result = UtilsMaster::Master.get_all_sites() rescue nil
    
    assert_kind_of(Array, result, "Return value expected to be an array")
  end

    
end
