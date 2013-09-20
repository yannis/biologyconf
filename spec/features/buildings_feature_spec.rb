require 'spec_helper'
include Warden::Test::Helpers             ## including some warden magic
Warden.test_mode!                         ## telling warden we are testing stuff


feature 'registration form', js: true do

  before {visit root_path(anchor: 'registration')}

  scenario 'I interact with the form' do
    expect(page).to have_title "biology14 - the Swiss conference on organismal biology"
    expect(page).to have_selector("form#new_registration")
    within("#new_registration") do
      expect(page).to have_selector("fieldset.registration-form-abstract", count: 1)
      expect(page).to have_text('Do you want to present a talk or a poster? no yes
', visible: true, count: 1)
      expect(page).to have_selector('.registration-form-abstract-collapse', visible: false, count: 1)
      page.find("#registration-form-abstract-show").click
      expect(page).to have_selector('.registration-form-abstract-collapse', visible: true, count: 1)
      page.find("#registration-form-abstract-hide").click
      expect(page).to have_selector('.registration-form-abstract-collapse', visible: false, count: 1)
    end
    # expect(page).to have_selector(".buildings-building", text: building1.name, count: 1)
    # page.find(".buildings-building a", text: building1.name).click
    # expect(current_url).to match "buildings/#{building1.id}$"
    # expect(page).to have_selector(".panel.building", count: 1)

    # within(".panel.building") do
    #   expect(page).to have_text(building1.name, count: 1)
    #   expect(page).to_not have_selector("a", text: 'Edit')
    # end


    # page.find(".panel.building button.close").click
    # expect(page).to_not have_selector(".panel.building")
    # expect(current_url).to match /\/#\/buildings$/
  end

end
