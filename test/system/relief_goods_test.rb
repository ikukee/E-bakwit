require "application_system_test_case"

class ReliefGoodsTest < ApplicationSystemTestCase
  setup do
    @relief_good = relief_goods(:one)
  end

  test "visiting the index" do
    visit relief_goods_url
    assert_selector "h1", text: "Relief goods"
  end

  test "should create relief good" do
    visit relief_goods_url
    click_on "New relief good"

    check "Is food" if @relief_good.is_food
    fill_in "Name", with: @relief_good.name
    fill_in "Price", with: @relief_good.price
    fill_in "Unit", with: @relief_good.unit
    click_on "Create Relief good"

    assert_text "Relief good was successfully created"
    click_on "Back"
  end

  test "should update Relief good" do
    visit relief_good_url(@relief_good)
    click_on "Edit this relief good", match: :first

    check "Is food" if @relief_good.is_food
    fill_in "Name", with: @relief_good.name
    fill_in "Price", with: @relief_good.price
    fill_in "Unit", with: @relief_good.unit
    click_on "Update Relief good"

    assert_text "Relief good was successfully updated"
    click_on "Back"
  end

  test "should destroy Relief good" do
    visit relief_good_url(@relief_good)
    click_on "Destroy this relief good", match: :first

    assert_text "Relief good was successfully destroyed"
  end
end
