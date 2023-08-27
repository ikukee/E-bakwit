require "test_helper"

class EvacCentersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @evac_center = evac_centers(:one)
  end

  test "should get index" do
    get evac_centers_url
    assert_response :success
  end

  test "should get new" do
    get new_evac_center_url
    assert_response :success
  end

  test "should create evac_center" do
    assert_difference("EvacCenter.count") do
      post evac_centers_url, params: { evac_center: { barangay: @evac_center.barangay, isInside: @evac_center.isInside, name: @evac_center.name } }
    end

    assert_redirected_to evac_center_url(EvacCenter.last)
  end

  test "should show evac_center" do
    get evac_center_url(@evac_center)
    assert_response :success
  end

  test "should get edit" do
    get edit_evac_center_url(@evac_center)
    assert_response :success
  end

  test "should update evac_center" do
    patch evac_center_url(@evac_center), params: { evac_center: { barangay: @evac_center.barangay, isInside: @evac_center.isInside, name: @evac_center.name } }
    assert_redirected_to evac_center_url(@evac_center)
  end

  test "should destroy evac_center" do
    assert_difference("EvacCenter.count", -1) do
      delete evac_center_url(@evac_center)
    end

    assert_redirected_to evac_centers_url
  end
end
