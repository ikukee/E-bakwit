require "test_helper"

class DisastersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @disaster = disasters(:one)
  end

  test "should get index" do
    get disasters_url
    assert_response :success
  end

  test "should get new" do
    get new_disaster_url
    assert_response :success
  end

  test "should create disaster" do
    assert_difference("Disaster.count") do
      post disasters_url, params: { disaster: { disaster_type: @disaster.disaster_type, name: @disaster.name, year: @disaster.year } }
    end

    assert_redirected_to disaster_url(Disaster.last)
  end

  test "should show disaster" do
    get disaster_url(@disaster)
    assert_response :success
  end

  test "should get edit" do
    get edit_disaster_url(@disaster)
    assert_response :success
  end

  test "should update disaster" do
    patch disaster_url(@disaster), params: { disaster: { disaster_type: @disaster.disaster_type, name: @disaster.name, year: @disaster.year } }
    assert_redirected_to disaster_url(@disaster)
  end

  test "should destroy disaster" do
    assert_difference("Disaster.count", -1) do
      delete disaster_url(@disaster)
    end

    assert_redirected_to disasters_url
  end
end
