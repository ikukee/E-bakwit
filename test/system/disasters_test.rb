require "application_system_test_case"

class DisastersTest < ApplicationSystemTestCase
  setup do
    @disaster = disasters(:one)
  end

  test "visiting the index" do
    visit disasters_url
    assert_selector "h1", text: "Disasters"
  end

  test "should create disaster" do
    visit disasters_url
    click_on "New disaster"

    fill_in "Disaster type", with: @disaster.disaster_type
    fill_in "Name", with: @disaster.name
    fill_in "Year", with: @disaster.year
    click_on "Create Disaster"

    assert_text "Disaster was successfully created"
    click_on "Back"
  end

  test "should update Disaster" do
    visit disaster_url(@disaster)
    click_on "Edit this disaster", match: :first

    fill_in "Disaster type", with: @disaster.disaster_type
    fill_in "Name", with: @disaster.name
    fill_in "Year", with: @disaster.year
    click_on "Update Disaster"

    assert_text "Disaster was successfully updated"
    click_on "Back"
  end

  test "should destroy Disaster" do
    visit disaster_url(@disaster)
    click_on "Destroy this disaster", match: :first

    assert_text "Disaster was successfully destroyed"
  end
end
