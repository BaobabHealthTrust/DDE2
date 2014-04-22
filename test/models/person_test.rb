require 'test_helper'

class PersonTest < ActiveSupport::TestCase
  
  test "check if process_person_data argument is a JSON Object" do
    exception = assert_raises(RuntimeError) {
      Person.process_person_data("random string") 
    }
    
    assert_equal("First argument can only be a JSON Object", exception.message)    
  end
    
  test "check if record_has_v4_id argument is a JSON Object" do
    exception = assert_raises(RuntimeError) {
      Person.record_has_v4_id("random string") 
    }
    
    assert_equal("First argument can only be a JSON Object", exception.message)
  end   
  
  test "check if search_for_record_by_params first argument is not blank" do
    
    exception = assert_raises(RuntimeError) {
      Person.search_for_record_by_params("", "test", "test") 
    }
    
    assert_equal("First argument cannot be blank", exception.message)
  end 
    
  test "check if search_for_record_by_params second argument is not blank" do
    exception = assert_raises(RuntimeError) {
      Person.search_for_record_by_params("test", "", "test") 
    }
    
    assert_equal("Second argument cannot be blank", exception.message)
  end
  
  test "check if search_for_record_by_params third argument is not blank" do
    exception = assert_raises(RuntimeError) {
      Person.search_for_record_by_params("test", "test", "") 
    }
    
    assert_equal("Third argument cannot be blank", exception.message)
  end
   
  test "check if confirm_record_to_update argument is a JSON Object" do
    exception = assert_raises(RuntimeError) {
      Person.confirm_record_to_update("random string") 
    }
    
    assert_equal("First argument can only be a JSON Object", exception.message)
  end   
  
  test "check if create_person_record argument is a JSON Object" do
    exception = assert_raises(RuntimeError) {
      Person.create_person_record("random string") 
    }
    
    assert_equal("First argument can only be a JSON Object", exception.message)
  end   
  
  test "check if update_person_record argument is a JSON Object" do
    exception = assert_raises(RuntimeError) {
      Person.update_person_record("random string") 
    }
    
    assert_equal("First argument can only be a JSON Object", exception.message)
  end   
  
  test "check if get_person_record argument is a JSON Object" do
    exception = assert_raises(RuntimeError) {
      Person.get_person_record("random string") 
    }
    
    assert_equal("First argument can only be a JSON Object", exception.message)
  end   
  
  test "check if search_by_npid argument is a a version 4 ID" do
    exception = assert_raises(RuntimeError) {
      Person.get_person_record("random string") 
    }
    
    assert_equal("First argument can only be a version 4 ID", exception.message)
  end   
  
  test "check if process_person_data result is a JSON Object" do
    result = Person.process_person_data('{}') rescue nil
    
    assert_not_nil(result, "Return value expected to be a JSON Object")
  end
  
end
