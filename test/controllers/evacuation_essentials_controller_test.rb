require "test_helper"

class EvacuationEssentialsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @evacuation_essential = evacuation_essentials(:one)
  end

  test "should get index" do
    get evacuation_essentials_url
    assert_response :success
  end

  test "should get new" do
    get new_evacuation_essential_url
    assert_response :success
  end

  test "should create evacuation_essential" do
    assert_difference("EvacuationEssential.count") do
      post evacuation_essentials_url, params: { evacuation_essential: { description: @evacuation_essential.description, ess_type: @evacuation_essential.ess_type, name: @evacuation_essential.name } }
    end

    assert_redirected_to evacuation_essential_url(EvacuationEssential.last)
  end

  test "should show evacuation_essential" do
    get evacuation_essential_url(@evacuation_essential)
    assert_response :success
  end

  test "should get edit" do
    get edit_evacuation_essential_url(@evacuation_essential)
    assert_response :success
  end

  test "should update evacuation_essential" do
    patch evacuation_essential_url(@evacuation_essential), params: { evacuation_essential: { description: @evacuation_essential.description, ess_type: @evacuation_essential.ess_type, name: @evacuation_essential.name } }
    assert_redirected_to evacuation_essential_url(@evacuation_essential)
  end

  test "should destroy evacuation_essential" do
    assert_difference("EvacuationEssential.count", -1) do
      delete evacuation_essential_url(@evacuation_essential)
    end

    assert_redirected_to evacuation_essentials_url
  end
end
