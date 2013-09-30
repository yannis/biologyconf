require 'spec_helper'
include Warden::Test::Helpers             ## including some warden magic
Warden.test_mode!                         ## telling warden we are testing stuff


feature 'registration form', js: true do

  before {visit root_path(anchor: 'registration')}

  scenario 'I interact with the form', focus: true do
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
  end

  let(:registration) {build :registration}
  scenario "I submit the form" do
    fill_in 'registration_first_name', :with => registration.first_name
    fill_in 'registration_last_name', :with => registration.last_name
    fill_in 'registration_email', :with => registration.email
    fill_in 'registration_institute', :with => registration.institute
    fill_in 'registration_address', :with => registration.address
    fill_in 'registration_zip_code', :with => registration.zip_code
    fill_in 'registration_city', :with => registration.city
    select registration.country, :from => "registration_country"
    click_link_or_button "Send your registration"
    expect(page).to have_text('Confirm your registration data', visible: true, count: 1)
    click_link_or_button "Pay your registration"
    expect(page).to have_text('Confirmation de la transaction', visible: true, count: 1)
    expect(page).to have_text('Erreur dans les paramètres', visible: true, count: 1)
  end
end
