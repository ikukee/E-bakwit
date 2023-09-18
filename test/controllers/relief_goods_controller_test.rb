require "test_helper"

class ReliefGoodsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @relief_good = relief_goods(:one)
  end

  test "should get index" do
    get relief_goods_url
    assert_response :success
  end

  test "should get new" do
    get new_relief_good_url
    assert_response :success
  end

  test "should create relief_good" do
    assert_difference("ReliefGood.count") do
      post relief_goods_url, params: { relief_good: { is_food: @relief_good.is_food, name: @relief_good.name, price: @relief_good.price, unit: @relief_good.unit } }
    end

    assert_redirected_to relief_good_url(ReliefGood.last)
  end

  test "should show relief_good" do
    get relief_good_url(@relief_good)
    assert_response :success
  end

  test "should get edit" do
    get edit_relief_good_url(@relief_good)
    assert_response :success
  end

  test "should update relief_good" do
    patch relief_good_url(@relief_good), params: { relief_good: { is_food: @relief_good.is_food, name: @relief_good.name, price: @relief_good.price, unit: @relief_good.unit } }
    assert_redirected_to relief_good_url(@relief_good)
  end

  test "should destroy relief_good" do
    assert_difference("ReliefGood.count", -1) do
      delete relief_good_url(@relief_good)
    end

    assert_redirected_to relief_goods_url
  end
end
