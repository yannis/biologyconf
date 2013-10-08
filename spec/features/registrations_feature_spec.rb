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
      expect(page).to have_text('Do you want to present a talk or a poster?', visible: true, count: 1)
      expect(page).to have_selector('.registration-form-abstract-collapse', visible: false, count: 1)
      page.find("#registration-form-abstract-show").click
      expect(page).to have_selector('.registration-form-abstract-collapse', visible: true, count: 1)
      page.find("#registration-form-abstract-hide").click
      expect(page).to have_selector('.registration-form-abstract-collapse', visible: false, count: 1)
    end
  end

  scenario "I change the items i'm registering for (dormitory, dinner)" do
    within("#new_registration") do
      expect(page).to have_selector('#registration-fees-total', visible: false, count: 1)
      within("#registration-fees-total") do
        expect(page).to have_text("Total: 0.1 CHF", visible: true, count: 1)
      end
      choose "30 CHF: Advanced researcher, member SZS, SSS, or SBS"
      within("#registration-fees-total") do
        expect(page).to_not have_text("Total: 63.1 CHF")
        expect(page).to have_text("Total: 30 CHF", visible: true, count: 1)
      end
      select "non-student: 60 CHF", :from => "registration_dinner_category_name"
      within("#registration-fees-total") do
        expect(page).to_not have_text("Total: 63.1 CHF")
        expect(page).to have_text("Total: 90 CHF", visible: true, count: 1)
      end
      check "22 CHF: per person per night"
      within("#registration-fees-total") do
        expect(page).to_not have_text("Total: 63.1 CHF")
        expect(page).to have_text("Total: 112 CHF", visible: true, count: 1)
      end
      select "student: 30 CHF", :from => "registration_dinner_category_name"
      within("#registration-fees-total") do
        expect(page).to_not have_text("Total: 83 CHF")
        expect(page).to have_text("Total: 82 CHF", visible: true, count: 1)
      end
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
