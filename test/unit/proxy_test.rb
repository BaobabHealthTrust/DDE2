require 'test_helper'

class UtilsProxyTest < ActiveSupport::TestCase  
  include Utils    
  
  # <!--------------------- Check for input parameters in this group ------------------------/>
  test "check if assign_npid_to_person argument is a JSON Object" do
    exception = assert_raises(RuntimeError) {
      Utils::Proxy.assign_npid_to_person("random string") 
    }
    
    assert_equal("First argument can only be a JSON Object", exception.message)    
  end
  
  test "check if assign_temporary_npid argument is a JSON Object" do
    exception = assert_raises(RuntimeError) {
      Utils::Proxy.assign_temporary_npid("random string") 
    }
    
    assert_equal("First argument can only be a JSON Object", exception.message)    
  end
    
  test "check if request_for_npids first argument is not blank" do
    
    exception = assert_raises(RuntimeError) {
      Utils::Proxy.request_for_npids(nil, "test") 
    }
    
    assert_equal("First argument cannot be blank", exception.message)
  end 
    
  test "check if request_for_npids second argument is not blank" do
    
    exception = assert_raises(RuntimeError) {
      Utils::Proxy.request_for_npids("test", nil) 
    }
    
    assert_equal("Second argument cannot be blank", exception.message)
  end 
    
  # <!----------------------------------- End of group --------------------------/>
  
  
  
  # <!------------------------------ Check return value types ---------------/>
  
  test "check if check_if_npids_available return result is a JSON Object" do
    result = Utils::Proxy.check_if_npids_available() rescue nil
    
    assert_not_nil(result, "Return value expected to be a boolean")
  end
  
  test "check if assign_npid_to_person return result is a JSON Object" do
    result = Utils::Proxy.assign_npid_to_person('{}') rescue nil
    
    assert_not_nil(result, "Return value expected to be a JSON Object")
  end
  
  test "check if assign_temporary_npid return result is a JSON Object" do
    result = Utils::Proxy.assign_temporary_npid('{}') rescue nil
    
    assert_not_nil(result, "Return value expected to be a JSON Object")
  end
  
  test "check if get_unassigned_npids return result is an array" do
    result = Utils::Proxy.get_unassigned_npids() rescue nil
    
    assert_kind_of(Array, result, "Return value expected to be an array")
  end

  test "check if request_for_npids return result is a JSON Object" do
    result = Utils::Proxy.request_for_npids("test", "test") rescue nil
    
    assert_not_nil(result, "Return value expected to be a boolean")
  end
  
end
