require "application_system_test_case"

class CampManagersTest < ApplicationSystemTestCase
  setup do
    @camp_manager = camp_managers(:one)
  end

  test "visiting the index" do
    visit camp_managers_url
    assert_selector "h1", text: "Camp managers"
  end

  test "should create camp manager" do
    visit camp_managers_url
    click_on "New camp manager"

    fill_in "Address", with: @camp_manager.address
    fill_in "Cnum", with: @camp_manager.cnum
    fill_in "Fname", with: @camp_manager.fname
    fill_in "Lname", with: @camp_manager.lname
    fill_in "Status", with: @camp_manager.status
    click_on "Create Camp manager"

    assert_text "Camp manager was successfully created"
    click_on "Back"
  end

  test "should update Camp manager" do
    visit camp_manager_url(@camp_manager)
    click_on "Edit this camp manager", match: :first

    fill_in "Address", with: @camp_manager.address
    fill_in "Cnum", with: @camp_manager.cnum
    fill_in "Fname", with: @camp_manager.fname
    fill_in "Lname", with: @camp_manager.lname
    fill_in "Status", with: @camp_manager.status
    click_on "Update Camp manager"

    assert_text "Camp manager was successfully updated"
    click_on "Back"
  end

  test "should destroy Camp manager" do
    visit camp_manager_url(@camp_manager)
    click_on "Destroy this camp manager", match: :first

    assert_text "Camp manager was successfully destroyed"
  end
end
