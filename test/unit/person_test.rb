require 'test_helper'

class UtilsPersonTest < ActiveSupport::TestCase  
  include Utils    
  
  # <!--------------------- Check for input parameters in this group ------------------------/>
  test "check if process_person_data argument is a JSON Object" do
    exception = assert_raises(RuntimeError) {
      Utils::Person.process_person_data("random string") 
    }
    
    assert_equal("First argument can only be a JSON Object", exception.message)    
  end
    
  test "check if record_has_v4_id argument is a JSON Object" do
    exception = assert_raises(RuntimeError) {
      Utils::Person.record_has_v4_id("random string") 
    }
    
    assert_equal("First argument can only be a JSON Object", exception.message)
  end   
  
  test "check if search_for_record_by_params first argument is not blank" do
    
    exception = assert_raises(RuntimeError) {
      Utils::Person.search_for_record_by_params("", "test", "test") 
    }
    
    assert_equal("First argument cannot be blank", exception.message)
  end 
    
  test "check if search_for_record_by_params second argument is not blank" do
    exception = assert_raises(RuntimeError) {
      Utils::Person.search_for_record_by_params("test", "", "test") 
    }
    
    assert_equal("Second argument cannot be blank", exception.message)
  end
  
  test "check if search_for_record_by_params third argument is not blank" do
    exception = assert_raises(RuntimeError) {
      Utils::Person.search_for_record_by_params("test", "test", "") 
    }
    
    assert_equal("Third argument cannot be blank", exception.message)
  end
   
  test "check if confirm_record_to_update argument is a JSON Object" do
    exception = assert_raises(RuntimeError) {
      Utils::Person.confirm_record_to_update("random string") 
    }
    
    assert_equal("First argument can only be a JSON Object", exception.message)
  end   
  
  test "check if create_person_record argument is a JSON Object" do
    exception = assert_raises(RuntimeError) {
      Utils::Person.create_person_record("random string") 
    }
    
    assert_equal("First argument can only be a JSON Object", exception.message)
  end   
  
  test "check if update_person_record argument is a JSON Object" do
    exception = assert_raises(RuntimeError) {
      Utils::Person.update_person_record("random string") 
    }
    
    assert_equal("First argument can only be a JSON Object", exception.message)
  end   
  
  test "check if get_person_record argument is a JSON Object" do
    exception = assert_raises(RuntimeError) {
      Utils::Person.get_person_record("random string") 
    }
    
    assert_equal("First argument can only be a JSON Object", exception.message)
  end   
  
  test "check if search_by_npid argument is a a version 4 ID" do
    exception = assert_raises(RuntimeError) {
      Utils::Person.get_person_record("random string") 
    }
    
    assert_equal("First argument can only be a version 4 ID", exception.message)
  end   
  
  # <!----------------------------------- End of group --------------------------/>
  
  
  
  # <!------------------------------ Check return value types ---------------/>
  
  test "check if process_person_data return result is a JSON Object" do
    result = Utils::Person.process_person_data('{}') rescue nil
    
    assert_not_nil(result, "Return value expected to be a JSON Object")
  end
  
  test "check if record_has_v4_id return result is a boolean" do
    result = Utils::Person.record_has_v4_id('{}') rescue nil
    
    assert_not_nil(result, "Return value expected to be a boolean")
  end

  test "check if search_for_record_by_params return result is a JSON Object" do
    result = Utils::Person.search_for_record_by_params("test", "test", "test")  rescue nil
    
    assert_not_nil(result, "Return value expected to be a JSON Object")
  end
  
  test "check if confirm_record_to_update return result is an array" do
    result = Utils::Person.confirm_record_to_update('{}') rescue nil
    
    assert_kind_of(Array, result, "Return value expected to be an array")
  end

  test "check if create_person_record return result is a boolean" do
    result = Utils::Person.create_person_record('{}') rescue nil
    
    assert_not_nil(result, "Return value expected to be a boolean")
  end

  test "check if update_person_record return result is a boolean" do
    result = Utils::Person.update_person_record('{}') rescue nil
    
    assert_not_nil(result, "Return value expected to be a boolean")
  end

  test "check if get_person_record return result is a JSON Object" do
    result = Utils::Person.get_person_record("XXXXXX") rescue nil
    
    assert_not_nil(result, "Return value expected to be a JSON Object")
  end
  
  test "check if search_by_npid return result is an array" do
    result = Utils::Person.search_by_npid("XXXXXX") rescue nil
    
    assert_kind_of(Array, result, "Return value expected to be an array")
  end

  # <!-------------------------- End of group ------------------------------/>
  
end