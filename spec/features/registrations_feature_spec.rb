require 'spec_helper'
include Warden::Test::Helpers             ## including some warden magic
Warden.test_mode!                         ## telling warden we are testing stuff


feature 'registration form', js: true do

  before {visit root_path(anchor: 'registration')}

  scenario 'I interact with the form' do
    expect(page).to have_title "biology14 - the Swiss conference on organismal biology"
    expect(page).to have_selector("form#registration-form")
    within("#registration-form") do
      expect(page).to have_selector("fieldset.registration-form-abstract", count: 1)
      expect(page).to have_text('Submit a talk or poster abstract', visible: true, count: 1)
      # expect(page).to have_selector('.registration-form-abstract-collapse', visible: false, count: 1)
      # page.find("#registration-form-abstract-show").click
      # expect(page).to have_selector('.registration-form-abstract-collapse', visible: true, count: 1)
      # page.find("#registration-form-abstract-hide").click
      # expect(page).to have_selector('.registration-form-abstract-collapse', visible: false, count: 1)
    end
  end

  scenario "I change the items i'm registering for (dormitory, dinner)" do
    within("#registration-form") do
      expect(page).to have_selector('#registration-fees-total', visible: false, count: 1)
      within("#registration-fees-total") do
        expect(page).to have_text("Total fees: 0.1 CHF", visible: true, count: 1)
      end
      choose "35 CHF: advanced researcher, member SZS, SSS, or SBS"
      within("#registration-fees-total") do
        expect(page).to_not have_text("Total fees: 63.1 CHF")
        expect(page).to have_text("Total fees: 35 CHF", visible: true, count: 1)
      end
      select "non-student: 55 CHF", from: "registration_dinner_category_name"
      within("#registration-fees-total") do
        expect(page).to_not have_text("Total fees: 63.1 CHF")
        expect(page).to have_text("Total fees: 90 CHF", visible: true, count: 1)
      end
      check "Vegetarian meal"
      within("#registration-fees-total") do
        expect(page).to_not have_text("Total fees: 63.1 CHF")
        expect(page).to have_text("Total fees: 90 CHF", visible: true, count: 1)
      end
      check "26 CHF: per person per night"
      within("#registration-fees-total") do
        expect(page).to_not have_text("Total fees: 63.1 CHF")
        expect(page).to have_text("Total fees: 116 CHF", visible: true, count: 1)
      end
      select "student: 30 CHF", from: "registration_dinner_category_name"
      within("#registration-fees-total") do
        expect(page).to_not have_text("Total fees: 83 CHF")
        expect(page).to have_text("Total fees: 91 CHF", visible: true, count: 1)
      end
    end
  end

  let(:registration) {build :registration}
  scenario "I submit the form" do
    fill_in 'registration_first_name', with: registration.first_name
    fill_in 'registration_last_name', with: registration.last_name
    fill_in 'registration_email', with: registration.email
    fill_in 'registration_institute', with: registration.institute
    fill_in 'registration_address', with: registration.address
    fill_in 'registration_zip_code', with: registration.zip_code
    fill_in 'registration_city', with: registration.city
    select registration.country, from: "registration_country"
    click_link_or_button "Submit your registration"
    expect(page).to have_text('Confirm your registration data', visible: true, count: 1)
    click_link_or_button "Pay your registration"
    expect(page).to have_text('Confirmation de la transaction', visible: true, count: 1)
    expect(page).to have_text('Erreur dans les paramètres', visible: true, count: 1)
  end

  scenario "I change the dinner category" do
    within("#registration-form") do
      expect(page).to have_selector('#registration-vegetarian:disabled', count: 1)
      select "student: 30 CHF", from: "registration_dinner_category_name"
      expect(page).to_not have_selector('#registration-vegetarian:disabled')
      expect(page).to have_selector('#registration-vegetarian', count: 1)
      select "Please select", from: "registration_dinner_category_name"
      expect(page).to have_selector('#registration-vegetarian:disabled', count: 1)
    end
  end

  scenario "I change the talk category" do
    within("#registration-form") do
      expect(page).to have_selector("input[name='registration[poster_agreement]']:disabled", count: 2)
      choose "Talk"
      expect(page).to_not have_selector("input[name='registration[poster_agreement]']:disabled")
      expect(page).to have_selector("input[name='registration[poster_agreement]']", count: 2)
      choose "Poster"
      expect(page).to have_selector("input[name='registration[poster_agreement]']:disabled", count: 2)
    end
  end

  scenario "The abstract body textarea should be wysiwyg" do
    within("#registration-form") do
      expect(page).to have_text "bold italic h1 h2 p unordered list ordered list"
      fill_registration_abstract "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
      sleep 0.5
      click_link_or_button "unordered list"
    end
  end
end
