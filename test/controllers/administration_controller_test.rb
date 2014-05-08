require 'test_helper'

class AdministrationControllerTest < ActionController::TestCase
  test "should get site_add" do
    get :site_add
    assert_response :success
  end

  test "should get site_edit" do
    get :site_edit
    assert_response :success
  end

  test "should get site_show" do
    get :site_show
    assert_response :success
  end

  test "should get region_add" do
    get :region_add
    assert_response :success
  end

  test "should get region_edit" do
    get :region_edit
    assert_response :success
  end

  test "should get region_show" do
    get :region_show
    assert_response :success
  end

  test "should get user_add" do
    get :user_add
    assert_response :success
  end

  test "should get user_edit" do
    get :user_edit
    assert_response :success
  end

  test "should get user_show" do
    get :user_show
    assert_response :success
  end

  test "should get master_people" do
    get :master_people
    assert_response :success
  end

  test "should get proxy_people" do
    get :proxy_people
    assert_response :success
  end

end
