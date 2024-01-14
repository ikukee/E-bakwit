require "application_system_test_case"

class EvacuationEssentialsTest < ApplicationSystemTestCase
  setup do
    @evacuation_essential = evacuation_essentials(:one)
  end

  test "visiting the index" do
    visit evacuation_essentials_url
    assert_selector "h1", text: "Evacuation essentials"
  end

  test "should create evacuation essential" do
    visit evacuation_essentials_url
    click_on "New evacuation essential"

    fill_in "Description", with: @evacuation_essential.description
    fill_in "Ess type", with: @evacuation_essential.ess_type
    fill_in "Name", with: @evacuation_essential.name
    click_on "Create Evacuation essential"

    assert_text "Evacuation essential was successfully created"
    click_on "Back"
  end

  test "should update Evacuation essential" do
    visit evacuation_essential_url(@evacuation_essential)
    click_on "Edit this evacuation essential", match: :first

    fill_in "Description", with: @evacuation_essential.description
    fill_in "Ess type", with: @evacuation_essential.ess_type
    fill_in "Name", with: @evacuation_essential.name
    click_on "Update Evacuation essential"

    assert_text "Evacuation essential was successfully updated"
    click_on "Back"
  end

  test "should destroy Evacuation essential" do
    visit evacuation_essential_url(@evacuation_essential)
    click_on "Destroy this evacuation essential", match: :first

    assert_text "Evacuation essential was successfully destroyed"
  end
end
