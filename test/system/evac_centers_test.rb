require "application_system_test_case"

class EvacCentersTest < ApplicationSystemTestCase
  setup do
    @evac_center = evac_centers(:one)
  end

  test "visiting the index" do
    visit evac_centers_url
    assert_selector "h1", text: "Evac centers"
  end

  test "should create evac center" do
    visit evac_centers_url
    click_on "New evac center"

    fill_in "Barangay", with: @evac_center.barangay
    check "Isinside" if @evac_center.isInside
    fill_in "Name", with: @evac_center.name
    click_on "Create Evac center"

    assert_text "Evac center was successfully created"
    click_on "Back"
  end

  test "should update Evac center" do
    visit evac_center_url(@evac_center)
    click_on "Edit this evac center", match: :first

    fill_in "Barangay", with: @evac_center.barangay
    check "Isinside" if @evac_center.isInside
    fill_in "Name", with: @evac_center.name
    click_on "Update Evac center"

    assert_text "Evac center was successfully updated"
    click_on "Back"
  end

  test "should destroy Evac center" do
    visit evac_center_url(@evac_center)
    click_on "Destroy this evac center", match: :first

    assert_text "Evac center was successfully destroyed"
  end
end
