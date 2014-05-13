require 'test_helper'

class UtilsPersonTest < ActiveSupport::TestCase  
  include Utils    
  
  # <!--------------------- Check for input parameters in this group ------------------------/>
  test "process_person_data argument is a JSON Object" do
    exception = assert_raises(RuntimeError) {
      Utils::UPerson.process_person_data("random string")
    }
    
    assert_equal("Argument can only be a JSON Object", exception.message)    
  end
    
  test "check if person_has_v4_id argument is a JSON Object" do
    exception = assert_raises(RuntimeError) {
      Utils::UPerson.person_has_v4_id("random string")
    }
    
    assert_equal("Argument can only be a JSON Object", exception.message)
  end   
  
  test "check if search_for_person_by_params first argument is not blank" do
    
    exception = assert_raises(RuntimeError) {
      Utils::UPerson.search_for_person_by_params("", "test", "test")
    }
    
    assert_equal("First argument cannot be blank", exception.message)
  end 
    
  test "check if search_for_person_by_params second argument is not blank" do
    exception = assert_raises(RuntimeError) {
      Utils::UPerson.search_for_person_by_params("test", "", "test")
    }
    
    assert_equal("Second argument cannot be blank", exception.message)
  end
  
  test "check if search_for_person_by_params third argument is not blank" do
    exception = assert_raises(RuntimeError) {
      Utils::UPerson.search_for_person_by_params("test", "test", "")
    }
    
    assert_equal("Third argument cannot be blank", exception.message)
  end
   
  test "check if confirmed_person_to_update_or_select argument is a JSON Object" do
    exception = assert_raises(RuntimeError) {
      Utils::UPerson.confirmed_person_to_create_or_update_or_select("random string")
    }
    
    assert_equal("Argument can only be a JSON Object", exception.message)
  end   
  
  test "check if create_person argument is a JSON Object" do
    exception = assert_raises(RuntimeError) {
      Utils::UPerson.create_person("random string")
    }
    
    assert_equal("Argument can only be a JSON Object", exception.message)
  end   
  
  test "check if update_person argument is a JSON Object" do
    exception = assert_raises(RuntimeError) {
      Utils::UPerson.update_person("random string")
    }
    
    assert_equal("Argument can only be a JSON Object", exception.message)
  end   
  
  test "check if get_person argument is a valid version 4 ID" do
    exception = assert_raises(RuntimeError) {
      Utils::UPerson.get_person("random string")
    }
    
    assert_equal("Argument expected to be a valid version 4 ID", exception.message)
  end   
  
  test "check if search_by_npid argument is a version 4 ID" do
    exception = assert_raises(RuntimeError) {
      Utils::UPerson.search_by_npid("random string")
    }
    
    assert_equal("Argument can only be a JSON Object", exception.message)
  end   
  
  # <!----------------------------------- End of group --------------------------/>
  
  
  
  # <!------------------------------ Check return value types ---------------/>
  
  test "check if process_person_data return result is an array" do
    result = Utils::UPerson.process_person_data("{\"national_id\":\"000000\",\"application\":\"test\",\"site_code\":\"TST\",\"names\":{\"family_name\":\"Test\",\"given_name\":\"Test\"},\"gender\":\"M\",\"attributes\":{\"occupation\":\"\",\"cell_phone_number\":\"\"},\"birthdate\":\"2000-01-01\",\"patient\":{\"identifiers\":{\"other_identifier\":\"\"}},\"birthdate_estimated\":0,\"addresses\":{\"current_residence\":null,\"current_village\":null,\"current_ta\":null,\"current_district\":null,\"home_village\":null,\"home_ta\":null,\"home_district\":null}}") rescue nil
    
    assert_kind_of(Array,result, "Return value expected to be an array")
  end
  
  test "check if person_has_v4_id return result is a boolean" do
    result = Utils::UPerson.person_has_v4_id('{}') rescue nil
    
    assert_not_nil(result, "Return value expected to be a boolean")
  end

  test "check if search_for_person_by_params return result is a array" do
    result = Utils::UPerson.search_for_person_by_params("test", "test", "test")  rescue nil
    
    assert_kind_of(Array,result, "Return value expected to be an array")
  end
  
  test "check if confirmed_person_to_create_or_update_or_select return result is similar to the input value" do
    Person.find_by__id("000000").destroy rescue nil

    result = Utils::UPerson.create_person("{\"national_id\":\"000000\",\"application\":\"test\",\"site_code\":\"TST\",\"names\":{\"family_name\":\"Test\",\"given_name\":\"Test\"},\"gender\":\"M\",\"attributes\":{\"occupation\":\"\",\"cell_phone_number\":\"\"},\"birthdate\":\"2000-01-01\",\"patient\":{\"identifiers\":{\"other_identifier\":\"\"}},\"birthdate_estimated\":0,\"addresses\":{\"current_residence\":null,\"current_village\":null,\"current_ta\":null,\"current_district\":null,\"home_village\":null,\"home_ta\":null,\"home_district\":null}}") rescue nil
    
    if !result.nil?
      result = Utils::UPerson.confirmed_person_to_create_or_update_or_select("{\"national_id\":\"000000\",\"application\":\"test\",\"site_code\":\"TST\",\"names\":{\"family_name\":\"Test\",\"given_name\":\"Test\"},\"gender\":\"M\",\"attributes\":{\"occupation\":\"\",\"cell_phone_number\":\"\"},\"birthdate\":\"2000-01-01\",\"patient\":{\"identifiers\":{\"other_identifier\":\"\"}},\"birthdate_estimated\":0,\"addresses\":{\"current_residence\":null,\"current_village\":null,\"current_ta\":null,\"current_district\":null,\"home_village\":null,\"home_ta\":null,\"home_district\":null}}") rescue nil
    end
    
    assert_equal("{\"national_id\":\"000000\",\"application\":\"test\",\"site_code\":\"TST\",\"names\":{\"family_name\":\"Test\",\"given_name\":\"Test\"},\"gender\":\"M\",\"attributes\":{\"occupation\":\"\",\"cell_phone_number\":\"\"},\"birthdate\":\"2000-01-01\",\"patient\":{\"identifiers\":{\"other_identifier\":\"\"}},\"birthdate_estimated\":0,\"addresses\":{\"current_residence\":null,\"current_village\":null,\"current_ta\":null,\"current_district\":null,\"home_village\":null,\"home_ta\":null,\"home_district\":null}}", result, "Return value expected to be similar to input value")
  end

  test "check if update_person return result is a boolean" do
    result = Utils::UPerson.update_person('{}') rescue nil
    
    assert_not_nil(result, "Return value expected to be a boolean")
  end

  test "check if get_person return result is a JSON Object" do
    result = Utils::UPerson.get_person("03J-LEA") rescue nil
    
    assert_not_nil(result, "Return value expected to be a JSON Object")
  end
  
  test "check if search_by_npid return result is an array" do
    result = Utils::UPerson.search_by_npid("{\"national_id\":\"000000\",\"application\":\"test\",\"site_code\":\"TST\",\"names\":{\"family_name\":\"Test\",\"given_name\":\"Test\"},\"gender\":\"M\",\"attributes\":{\"occupation\":\"\",\"cell_phone_number\":\"\"},\"birthdate\":\"2000-01-01\",\"patient\":{\"identifiers\":{\"other_identifier\":\"\"}},\"birthdate_estimated\":0,\"addresses\":{\"current_residence\":null,\"current_village\":null,\"current_ta\":null,\"current_district\":null,\"home_village\":null,\"home_ta\":null,\"home_district\":null}}") rescue nil
    
    assert_kind_of(Array, result, "Return value expected to be an array")
  end
  # <!-------------------------- End of group ------------------------------/>
  
  # <!------------------------------ Check effect of methods ---------------/>
  
  test "check if confirmed_person_to_create_or_update_or_select(json, 'create') where no npids are available creates a new record" do
    json = "{\"national_id\":\"\",\"application\":\"test\",\"site_code\":\"TST\",\"names\":{\"family_name\":\"Test\",\"given_name\":\"Test\"},\"gender\":\"M\",\"attributes\":{\"occupation\":\"\",\"cell_phone_number\":\"\"},\"birthdate\":\"2000-01-01\",\"patient\":{\"identifiers\":{\"other_identifier\":\"\"}},\"birthdate_estimated\":0,\"addresses\":{\"current_residence\":null,\"current_village\":null,\"current_ta\":null,\"current_district\":null,\"home_village\":null,\"home_ta\":null,\"home_district\":null}}"
    
    count = 0
    
    obj = JSON.parse(json)
        
    u = Utils::UPerson.confirmed_person_to_create_or_update_or_select(json, 'create') rescue nil
    
    output = JSON.parse(u)
    
    result = ((!output["national_id"].match(/^[A-Z]{3}\d{14}$/).nil?) rescue false)
    
    assert_equal(true, result, "Final record expected to have a temporary ID")
  end

  test "check if confirmed_person_to_create_or_update_or_select(json, 'select') where temporary npids are replaced with new npids when they are available" do
    json = "{\"national_id\":\"\",\"application\":\"test\",\"site_code\":\"TST\",\"names\":{\"family_name\":\"Test\",\"given_name\":\"Test\"},\"gender\":\"M\",\"attributes\":{\"occupation\":\"\",\"cell_phone_number\":\"\"},\"birthdate\":\"2000-01-01\",\"patient\":{\"identifiers\":[]},\"birthdate_estimated\":0,\"addresses\":{\"current_residence\":null,\"current_village\":null,\"current_ta\":null,\"current_district\":null,\"home_village\":null,\"home_ta\":null,\"home_district\":null}}"
    
    count = 0
    
    obj = JSON.parse(json)
        
    u = Utils::UPerson.confirmed_person_to_create_or_update_or_select(json, 'create') rescue nil
    
    output = JSON.parse(u)
    
    result = ((!output["national_id"].match(/^[A-Z]{3}\d{14}$/).nil?) rescue false)
    
    assert_equal(true, result, "Initial test expected to have a temporary ID")
    
    # If site exists delete
    Site.find_by__id("TST").destroy rescue nil
    
    # Create site
    Utils::Master.add_site("Test Site", "TST", "Centre", 1, 1)
    
    # Check if region has npids
    if !Utils::Master.check_if_region_npids_available()
      Utils::Master.assign_npids_to_region("Centre", 10)
    end
    
    # Check if site has npids
    if !Utils::Proxy.check_if_npids_available()
      Utils::Master.assign_npids_to_site("TST", 1)
    end
    
    u = Utils::UPerson.confirmed_person_to_create_or_update_or_select(u, 'select') # rescue nil
    
    output2 = JSON.parse(u)
    
    result = ((output2["national_id"].length <= 7 and output2["national_id"].length >= 6 and output["national_id"] != output2["national_id"]) rescue false)
    
    assert_equal(true, result, "Temporary IDs after scanning where new NPIDs are available are expected to be updated to a version 4 ID")
  end

  test "check if confirmed_person_to_create_or_update_or_select(json, 'create') where npids are available creates a new record" do
    json = "{\"national_id\":\"\",\"application\":\"test\",\"site_code\":\"TST\",\"names\":{\"family_name\":\"Test\",\"given_name\":\"Test\"},\"gender\":\"M\",\"attributes\":{\"occupation\":\"\",\"cell_phone_number\":\"\"},\"birthdate\":\"2000-01-01\",\"patient\":{\"identifiers\":{\"other_identifier\":\"\"}},\"birthdate_estimated\":0,\"addresses\":{\"current_residence\":null,\"current_village\":null,\"current_ta\":null,\"current_district\":null,\"home_village\":null,\"home_ta\":null,\"home_district\":null}}"
    
    # If site exists delete
    Site.find_by__id("TST").destroy rescue nil
    
    # Create site
    Utils::Master.add_site("Test Site", "TST", "Centre", 1, 1)
    
    # Check if region has npids
    if !Utils::Master.check_if_region_npids_available()
      Utils::Master.assign_npids_to_region("Centre", 10)
    end
    
    # Check if site has npids
    if !Utils::Proxy.check_if_npids_available()
      Utils::Master.assign_npids_to_site("TST", 1)
    end
    
    obj = JSON.parse(json)
    
    u = Utils::UPerson.confirmed_person_to_create_or_update_or_select(json, 'create') rescue nil
    
    output = JSON.parse(u)
    
    result = ((output["national_id"].length <= 7 and output["national_id"].length >= 6) rescue false)
    
    assert_equal(true, result, "Final record expected to have a version 4 ID")
  end


  test "check if is_valid_v4_npid('random string') returns false" do
    result = Utils::UPerson.is_valid_v4_npid('random string') rescue nil
    
    assert_equal(false, result, "Return value expected to be a false")
  end
  
  test "check if is_valid_v4_npid('XXXXXX') returns false" do
    result = Utils::UPerson.is_valid_v4_npid('XXXXXX') rescue nil
    
    assert_equal(false, result, "Return value expected to be a false")
  end
  
  test "check if is_valid_v4_npid('03J-LEA') returns true" do
    result = Utils::UPerson.is_valid_v4_npid('03J-LEA') rescue nil
    
    assert_equal(true, result, "Return value expected to be a true")
  end
  
  test "check if person_has_v4_id(json) returns true" do
    result = Utils::UPerson.person_has_v4_id("{\"national_id\":\"000000\",\"application\":\"test\",\"site_code\":\"TST\",\"names\":{\"family_name\":\"Test\",\"given_name\":\"Test\"},\"gender\":\"M\",\"attributes\":{\"occupation\":\"\",\"cell_phone_number\":\"\"},\"birthdate\":\"2000-01-01\",\"patient\":{\"identifiers\":{\"other_identifier\":\"\"}},\"birthdate_estimated\":0,\"addresses\":{\"current_residence\":null,\"current_village\":null,\"current_ta\":null,\"current_district\":null,\"home_village\":null,\"home_ta\":null,\"home_district\":null}}") rescue nil
    
    assert_equal(true, result, "Return value expected to be a true")
  end
  
  test "check if person_has_v4_id(json) returns false" do
    result = Utils::UPerson.person_has_v4_id("{\"national_id\":\"XXXXXX\",\"application\":\"test\",\"site_code\":\"TST\",\"names\":{\"family_name\":\"Test\",\"given_name\":\"Test\"},\"gender\":\"M\",\"attributes\":{\"occupation\":\"\",\"cell_phone_number\":\"\"},\"birthdate\":\"2000-01-01\",\"patient\":{\"identifiers\":{\"other_identifier\":\"\"}},\"birthdate_estimated\":0,\"addresses\":{\"current_residence\":null,\"current_village\":null,\"current_ta\":null,\"current_district\":null,\"home_village\":null,\"home_ta\":null,\"home_district\":null}}") rescue nil
    
    assert_equal(false, result, "Return value expected to be a false")
  end
  
  test "check if create_person(json) returns true" do
    Person.find_by__id("000000").destroy rescue nil

    result = Utils::UPerson.create_person("{\"national_id\":\"000000\",\"application\":\"test\",\"site_code\":\"TST\",\"names\":{\"family_name\":\"Test\",\"given_name\":\"Test\"},\"gender\":\"M\",\"attributes\":{\"occupation\":\"\",\"cell_phone_number\":\"\"},\"birthdate\":\"2000-01-01\",\"patient\":{\"identifiers\":{\"other_identifier\":\"\"}},\"birthdate_estimated\":0,\"addresses\":{\"current_residence\":null,\"current_village\":null,\"current_ta\":null,\"current_district\":null,\"home_village\":null,\"home_ta\":null,\"home_district\":null}}") rescue nil
    
    assert_equal(true, result, "Return value expected to be a true")
  end
  
  test "check if update_person(json) returns true" do
    Person.find_by__id("000000").destroy rescue nil

    result = Utils::UPerson.create_person("{\"national_id\":\"000000\",\"application\":\"test\",\"site_code\":\"TST\",\"names\":{\"family_name\":\"Test\",\"given_name\":\"Test\"},\"gender\":\"M\",\"attributes\":{\"occupation\":\"\",\"cell_phone_number\":\"\"},\"birthdate\":\"2000-01-01\",\"patient\":{\"identifiers\":{\"other_identifier\":\"\"}},\"birthdate_estimated\":0,\"addresses\":{\"current_residence\":null,\"current_village\":null,\"current_ta\":null,\"current_district\":null,\"home_village\":null,\"home_ta\":null,\"home_district\":null}}") rescue nil
    
    if !result.nil?
    
      result = Utils::UPerson.update_person("{\"national_id\":\"000000\",\"application\":\"test\",\"site_code\":\"TST\",\"names\":{\"family_name\":\"Tested\",\"given_name\":\"Test\"},\"gender\":\"M\",\"attributes\":{\"occupation\":\"\",\"cell_phone_number\":\"\"},\"birthdate\":\"2000-01-01\",\"patient\":{\"identifiers\":{\"other_identifier\":\"\"}},\"birthdate_estimated\":0,\"addresses\":{\"current_residence\":null,\"current_village\":null,\"current_ta\":null,\"current_district\":null,\"home_village\":null,\"home_ta\":null,\"home_district\":null}}") rescue nil
      
      if !result.nil?
        result = false
        
        person = Person.find_by__id("000000") rescue nil
        
        result = (person.names.family_name == "Tested") rescue false
      end
      
    end
    
    assert_equal(true, result, "Return value expected to be a true")
  end
  
  test "check if get_person(npid) returns valid json" do    
    result = false
        
    Person.find_by__id("000000").destroy rescue nil

    person = Utils::UPerson.create_person("{\"national_id\":\"000000\",\"application\":\"test\",\"site_code\":\"TST\",\"names\":{\"family_name\":\"Test\",\"given_name\":\"Test\"},\"gender\":\"M\",\"attributes\":{\"occupation\":\"\",\"cell_phone_number\":\"\"},\"birthdate\":\"2000-01-01\",\"patient\":{\"identifiers\":{\"other_identifier\":\"\"}},\"birthdate_estimated\":0,\"addresses\":{\"current_residence\":null,\"current_village\":null,\"current_ta\":null,\"current_district\":null,\"home_village\":null,\"home_ta\":null,\"home_district\":null}}") rescue nil
    
    if !person.nil?
    
      person = Utils::UPerson.get_person("000000") rescue nil
      
      if person != "{}"
        result = true
      end
      
    end
    
    assert_equal(true, result, "Return value expected to be a true")
  end
  
  test "check if search_by_npid(json) returns a valid array" do
    result = false
    
    Person.find_by__id("000000").destroy rescue nil
    Person.find_by__id("03JLEA").destroy rescue nil

    result1 = Utils::UPerson.create_person("{\"national_id\":\"000000\",\"application\":\"test\",\"site_code\":\"TST\",\"names\":{\"family_name\":\"Test\",\"given_name\":\"Test\"},\"gender\":\"M\",\"attributes\":{\"occupation\":\"\",\"cell_phone_number\":\"\"},\"birthdate\":\"2000-01-01\",\"patient\":{\"identifiers\":{\"other_identifier\":\"\"}},\"birthdate_estimated\":0,\"addresses\":{\"current_residence\":null,\"current_village\":null,\"current_ta\":null,\"current_district\":null,\"home_village\":null,\"home_ta\":null,\"home_district\":null}}") rescue nil
    
    # Please not that this is just an imaginary case which is not supposed to happen 
    # in reality where a legacy identifier is similar to a current version 4 ID
    result2 = Utils::UPerson.create_person("{\"national_id\":\"03JLEA\",\"application\":\"test\",\"site_code\":\"TST\",\"names\":{\"family_name\":\"Test2\",\"given_name\":\"Test2\"},\"gender\":\"F\",\"attributes\":{\"occupation\":\"\",\"cell_phone_number\":\"\"},\"birthdate\":\"2000-01-01\",\"patient\":{\"identifiers\":[\"000000\",\"P1700000111\"]},\"birthdate_estimated\":0,\"addresses\":{\"current_residence\":null,\"current_village\":null,\"current_ta\":null,\"current_district\":null,\"home_village\":null,\"home_ta\":null,\"home_district\":null}}") rescue nil
    
    # Check if our dummy records where created as they will help in the test
    if !result1.nil? and !result2.nil?
    
      records = Utils::UPerson.search_by_npid("{\"national_id\":\"000000\",\"application\":\"test\",\"site_code\":\"TST\"}") rescue []
      
      if !records.blank?
        result = false
        
        if records.length == 2
          result = true
        end
      end
      
    end
    
    assert_equal(true, result, "Return value expected to be a true")
  end
  
  # Tests for search_for_person_by_params(first_name, last_name, gender, date_of_birth=nil, home_t_a=nil, home_district=nil) method 
  
  test "check if search_for_person_by_params('Mary', 'Banda', 'F', '2000-01-01', 'Kabudula', 'Lilongwe') returns a valid array of JSON Objects" do
    result = false
    
    Person.find_by__id("000000").destroy rescue nil
    Person.find_by__id("03JLEA").destroy rescue nil
    Person.find_by__id("0CYAC3").destroy rescue nil
    Person.find_by__id("05E7U5").destroy rescue nil
    Person.find_by__id("009YWT").destroy rescue nil
    Person.find_by__id("04C2G5").destroy rescue nil
    Person.find_by__id("043NAW").destroy rescue nil

    resultset = []
    
    npids = ["000000", "03JLEA", "0CYAC3", "05E7U5", "009YWT", "04C2G5", "043NAW"]
    
    npids.each do |npid|
    
      row = Utils::UPerson.create_person("{\"national_id\":\"#{npid}\",\"application\":\"test\",\"site_code\":\"TST\",\"names\":{\"family_name\":\"Banda\",\"given_name\":\"Mary\"},\"gender\":\"F\",\"attributes\":{\"occupation\":\"\",\"cell_phone_number\":\"\"},\"birthdate\":\"2000-01-01\",\"patient\":{\"identifiers\":{\"other_identifier\":\"\"}},\"birthdate_estimated\":0,\"addresses\":{\"current_residence\":null,\"current_village\":null,\"current_ta\":null,\"current_district\":null,\"home_village\":null,\"home_ta\":\"Kabudula\",\"home_district\":\"Lilongwe\"}}") rescue nil
    
      resultset << row if !row.blank?
    
    end
    
    # Check if our dummy records where created as they will help in the test
    if resultset.length == npids.length
    
      records = Utils::UPerson.search_for_person_by_params('Mary', 'Banda', 'F', '2000-01-01', 'Kabudula', 'Lilongwe') # rescue []
      
      if !records.blank?
        result = false
        
        if records.length == npids.length
          result = true
        end
      end
      
    end
    
    assert_equal(true, result, "Return value expected to be a true")
  end
  
  test "check if search_for_person_by_params('Mary', 'Banda', 'F', '2000-01-01', 'Kabudula') returns a valid array of JSON Objects" do
    result = false
    
    Person.find_by__id("000000").destroy rescue nil
    Person.find_by__id("03JLEA").destroy rescue nil
    Person.find_by__id("0CYAC3").destroy rescue nil
    Person.find_by__id("05E7U5").destroy rescue nil
    Person.find_by__id("009YWT").destroy rescue nil
    Person.find_by__id("04C2G5").destroy rescue nil
    Person.find_by__id("043NAW").destroy rescue nil

    resultset = []
    
    npids = ["000000", "03JLEA", "0CYAC3", "05E7U5", "009YWT", "04C2G5", "043NAW"]
    
    npids.each do |npid|
    
      row = Utils::UPerson.create_person("{\"national_id\":\"#{npid}\",\"application\":\"test\",\"site_code\":\"TST\",\"names\":{\"family_name\":\"Banda\",\"given_name\":\"Mary\"},\"gender\":\"F\",\"attributes\":{\"occupation\":\"\",\"cell_phone_number\":\"\"},\"birthdate\":\"2000-01-01\",\"patient\":{\"identifiers\":{\"other_identifier\":\"\"}},\"birthdate_estimated\":0,\"addresses\":{\"current_residence\":null,\"current_village\":null,\"current_ta\":null,\"current_district\":null,\"home_village\":null,\"home_ta\":\"Kabudula\",\"home_district\":\"Lilongwe\"}}") rescue nil
    
      resultset << row if !row.blank?
    
    end
    
    # Check if our dummy records where created as they will help in the test
    if resultset.length == npids.length
    
      records = Utils::UPerson.search_for_person_by_params('Mary', 'Banda', 'F', '2000-01-01', 'Kabudula') # rescue []
      
      if !records.blank?
        result = false
        
        if records.length == npids.length
          result = true
        end
      end
      
    end
    
    assert_equal(true, result, "Return value expected to be a true")
  end
  
  test "check if search_for_person_by_params('Mary', 'Banda', 'F', '2000-01-01', 'Lilongwe') returns a valid array of JSON Objects" do
    result = false
    
    Person.find_by__id("000000").destroy rescue nil
    Person.find_by__id("03JLEA").destroy rescue nil
    Person.find_by__id("0CYAC3").destroy rescue nil
    Person.find_by__id("05E7U5").destroy rescue nil
    Person.find_by__id("009YWT").destroy rescue nil
    Person.find_by__id("04C2G5").destroy rescue nil
    Person.find_by__id("043NAW").destroy rescue nil

    resultset = []
    
    npids = ["000000", "03JLEA", "0CYAC3", "05E7U5", "009YWT", "04C2G5", "043NAW"]
    
    npids.each do |npid|
    
      row = Utils::UPerson.create_person("{\"national_id\":\"#{npid}\",\"application\":\"test\",\"site_code\":\"TST\",\"names\":{\"family_name\":\"Banda\",\"given_name\":\"Mary\"},\"gender\":\"F\",\"attributes\":{\"occupation\":\"\",\"cell_phone_number\":\"\"},\"birthdate\":\"2000-01-01\",\"patient\":{\"identifiers\":{\"other_identifier\":\"\"}},\"birthdate_estimated\":0,\"addresses\":{\"current_residence\":null,\"current_village\":null,\"current_ta\":null,\"current_district\":null,\"home_village\":null,\"home_ta\":\"Kabudula\",\"home_district\":\"Lilongwe\"}}") rescue nil
    
      resultset << row if !row.blank?
    
    end
    
    # Check if our dummy records where created as they will help in the test
    if resultset.length == npids.length
    
      records = Utils::UPerson.search_for_person_by_params('Mary', 'Banda', 'F', '2000-01-01', nil, 'Lilongwe') # rescue []
      
      if !records.blank?
        result = false
        
        if records.length == npids.length
          result = true
        end
      end
      
    end
    
    assert_equal(true, result, "Return value expected to be a true")
  end
  
  test "check if search_for_person_by_params('Mary', 'Banda', 'F', nil, nil, 'Lilongwe') returns a valid array of JSON Objects" do
    result = false
    
    Person.find_by__id("000000").destroy rescue nil
    Person.find_by__id("03JLEA").destroy rescue nil
    Person.find_by__id("0CYAC3").destroy rescue nil
    Person.find_by__id("05E7U5").destroy rescue nil
    Person.find_by__id("009YWT").destroy rescue nil
    Person.find_by__id("04C2G5").destroy rescue nil
    Person.find_by__id("043NAW").destroy rescue nil

    resultset = []
    
    npids = ["000000", "03JLEA", "0CYAC3", "05E7U5", "009YWT", "04C2G5", "043NAW"]
    
    npids.each do |npid|
    
      row = Utils::UPerson.create_person("{\"national_id\":\"#{npid}\",\"application\":\"test\",\"site_code\":\"TST\",\"names\":{\"family_name\":\"Banda\",\"given_name\":\"Mary\"},\"gender\":\"F\",\"attributes\":{\"occupation\":\"\",\"cell_phone_number\":\"\"},\"birthdate\":\"2000-01-01\",\"patient\":{\"identifiers\":{\"other_identifier\":\"\"}},\"birthdate_estimated\":0,\"addresses\":{\"current_residence\":null,\"current_village\":null,\"current_ta\":null,\"current_district\":null,\"home_village\":null,\"home_ta\":\"Kabudula\",\"home_district\":\"Lilongwe\"}}") rescue nil
    
      resultset << row if !row.blank?
    
    end
    
    # Check if our dummy records where created as they will help in the test
    if resultset.length == npids.length
    
      records = Utils::UPerson.search_for_person_by_params('Mary', 'Banda', 'F', nil, nil, 'Lilongwe') # rescue []
      
      if !records.blank?
        result = false
        
        if records.length == npids.length
          result = true
        end
      end
      
    end
    
    assert_equal(true, result, "Return value expected to be a true")
  end
  
  test "check if search_for_person_by_params('Mary', 'Banda', 'F', nil, 'Kabudula') returns a valid array of JSON Objects" do
    result = false
    
    Person.find_by__id("000000").destroy rescue nil
    Person.find_by__id("03JLEA").destroy rescue nil
    Person.find_by__id("0CYAC3").destroy rescue nil
    Person.find_by__id("05E7U5").destroy rescue nil
    Person.find_by__id("009YWT").destroy rescue nil
    Person.find_by__id("04C2G5").destroy rescue nil
    Person.find_by__id("043NAW").destroy rescue nil

    resultset = []
    
    npids = ["000000", "03JLEA", "0CYAC3", "05E7U5", "009YWT", "04C2G5", "043NAW"]
    
    npids.each do |npid|
    
      row = Utils::UPerson.create_person("{\"national_id\":\"#{npid}\",\"application\":\"test\",\"site_code\":\"TST\",\"names\":{\"family_name\":\"Banda\",\"given_name\":\"Mary\"},\"gender\":\"F\",\"attributes\":{\"occupation\":\"\",\"cell_phone_number\":\"\"},\"birthdate\":\"2000-01-01\",\"patient\":{\"identifiers\":{\"other_identifier\":\"\"}},\"birthdate_estimated\":0,\"addresses\":{\"current_residence\":null,\"current_village\":null,\"current_ta\":null,\"current_district\":null,\"home_village\":null,\"home_ta\":\"Kabudula\",\"home_district\":\"Lilongwe\"}}") rescue nil
    
      resultset << row if !row.blank?
    
    end
    
    # Check if our dummy records where created as they will help in the test
    if resultset.length == npids.length
    
      records = Utils::UPerson.search_for_person_by_params('Mary', 'Banda', 'F', nil, 'Kabudula') # rescue []
      
      if !records.blank?
        result = false
        
        if records.length == npids.length
          result = true
        end
      end
      
    end
    
    assert_equal(true, result, "Return value expected to be a true")
  end
  
  test "check if search_for_person_by_params('Mary', 'Banda', 'F', '2000-01-01') returns a valid array of JSON Objects" do
    result = false
    
    Person.find_by__id("000000").destroy rescue nil
    Person.find_by__id("03JLEA").destroy rescue nil
    Person.find_by__id("0CYAC3").destroy rescue nil
    Person.find_by__id("05E7U5").destroy rescue nil
    Person.find_by__id("009YWT").destroy rescue nil
    Person.find_by__id("04C2G5").destroy rescue nil
    Person.find_by__id("043NAW").destroy rescue nil

    resultset = []
    
    npids = ["000000", "03JLEA", "0CYAC3", "05E7U5", "009YWT", "04C2G5", "043NAW"]
    
    npids.each do |npid|
    
      row = Utils::UPerson.create_person("{\"national_id\":\"#{npid}\",\"application\":\"test\",\"site_code\":\"TST\",\"names\":{\"family_name\":\"Banda\",\"given_name\":\"Mary\"},\"gender\":\"F\",\"attributes\":{\"occupation\":\"\",\"cell_phone_number\":\"\"},\"birthdate\":\"2000-01-01\",\"patient\":{\"identifiers\":{\"other_identifier\":\"\"}},\"birthdate_estimated\":0,\"addresses\":{\"current_residence\":null,\"current_village\":null,\"current_ta\":null,\"current_district\":null,\"home_village\":null,\"home_ta\":\"Kabudula\",\"home_district\":\"Lilongwe\"}}") rescue nil
    
      resultset << row if !row.blank?
    
    end
    
    # Check if our dummy records where created as they will help in the test
    if resultset.length == npids.length
    
      records = Utils::UPerson.search_for_person_by_params('Mary', 'Banda', 'F', '2000-01-01') # rescue []
      
      if !records.blank?
        result = false
        
        if records.length == npids.length
          result = true
        end
      end
      
    end
    
    assert_equal(true, result, "Return value expected to be a true")
  end
  
  test "check if search_for_person_by_params('Mary', 'Banda', 'F') returns a valid array of JSON Objects" do
    result = false
    
    Person.find_by__id("000000").destroy rescue nil
    Person.find_by__id("03JLEA").destroy rescue nil
    Person.find_by__id("0CYAC3").destroy rescue nil
    Person.find_by__id("05E7U5").destroy rescue nil
    Person.find_by__id("009YWT").destroy rescue nil
    Person.find_by__id("04C2G5").destroy rescue nil
    Person.find_by__id("043NAW").destroy rescue nil

    resultset = []
    
    npids = ["000000", "03JLEA", "0CYAC3", "05E7U5", "009YWT", "04C2G5", "043NAW"]
    
    npids.each do |npid|
    
      row = Utils::UPerson.create_person("{\"national_id\":\"#{npid}\",\"application\":\"test\",\"site_code\":\"TST\",\"names\":{\"family_name\":\"Banda\",\"given_name\":\"Mary\"},\"gender\":\"F\",\"attributes\":{\"occupation\":\"\",\"cell_phone_number\":\"\"},\"birthdate\":\"2000-01-01\",\"patient\":{\"identifiers\":{\"other_identifier\":\"\"}},\"birthdate_estimated\":0,\"addresses\":{\"current_residence\":null,\"current_village\":null,\"current_ta\":null,\"current_district\":null,\"home_village\":null,\"home_ta\":\"Kabudula\",\"home_district\":\"Lilongwe\"}}") rescue nil
    
      resultset << row if !row.blank?
    
    end
    
    # Check if our dummy records where created as they will help in the test
    if resultset.length == npids.length
    
      records = Utils::UPerson.search_for_person_by_params('Mary', 'Banda', 'F') # rescue []
      
      if !records.blank?
        result = false
        
        if records.length == npids.length
          result = true
        end
      end
      
    end
    
    assert_equal(true, result, "Return value expected to be a true")
  end
  
  # <!-------------------------- End of group ------------------------------/>
  
end
