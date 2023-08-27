require "test_helper"

class CampManagersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @camp_manager = camp_managers(:one)
  end

  test "should get index" do
    get camp_managers_url
    assert_response :success
  end

  test "should get new" do
    get new_camp_manager_url
    assert_response :success
  end

  test "should create camp_manager" do
    assert_difference("CampManager.count") do
      post camp_managers_url, params: { camp_manager: { address: @camp_manager.address, cnum: @camp_manager.cnum, fname: @camp_manager.fname, lname: @camp_manager.lname, status: @camp_manager.status } }
    end

    assert_redirected_to camp_manager_url(CampManager.last)
  end

  test "should show camp_manager" do
    get camp_manager_url(@camp_manager)
    assert_response :success
  end

  test "should get edit" do
    get edit_camp_manager_url(@camp_manager)
    assert_response :success
  end

  test "should update camp_manager" do
    patch camp_manager_url(@camp_manager), params: { camp_manager: { address: @camp_manager.address, cnum: @camp_manager.cnum, fname: @camp_manager.fname, lname: @camp_manager.lname, status: @camp_manager.status } }
    assert_redirected_to camp_manager_url(@camp_manager)
  end

  test "should destroy camp_manager" do
    assert_difference("CampManager.count", -1) do
      delete camp_manager_url(@camp_manager)
    end

    assert_redirected_to camp_managers_url
  end
end
