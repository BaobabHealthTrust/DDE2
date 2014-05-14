require 'test_helper'

class ProcessControllerTest < ActionController::TestCase
  test "should get process_data" do
    get :process_data
    assert_response :success
  end

  test "should get search" do
    get :search
    assert_response :success
  end

end
