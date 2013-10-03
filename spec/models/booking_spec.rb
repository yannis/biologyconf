require 'spec_helper'

describe Booking do
  let(:registration){create :registration}
  let(:booking){Booking.new(registration)}
  it {expect(booking).to respond_to "registration"}
  it {expect(booking).to respond_to "params_hash"}
  it {expect(booking.params_hash.keys).to eql [:form_id, :key, "Prix", :firstname, :surname, :address, :npa, :town, :country_iso, :email, :payment_type, :gross_amount, :nb_place, :uni_id, :no_fonds, :centre_couts, "SAP-LINK"]}
  # it {expect(booking).to respond_to "url"}
  # it {expect(booking.url).to eql "https://cms.unige.ch/webtools/static/booking/946335/index.php?form_id=226&key=67C9BD2C6943CCD4377020C2ACE60762&Prix=50&firstname=#{registration.first_name}&surname=#{registration.last_name}&address=#{registration.address}&npa=#{registration.zip_code}&town=#{registration.city}&country_iso=#{Country.find_country_by_name(registration.country).alpha2}&email=#{registration.email}&payment_type=0&gross_amount=50&nb_place=1&uni_id=226-1&no_fonds=229707&centre_couts=229707&SAP-LINK=PRD"}

end
