require 'spec_helper'

def request(bookable)
  id = "226-#{bookable.timestamp_id}"
  req = Object.new
  req.stub(:remote_ip){"0.0.0.0"}
  req.stub(:params){{"id" => id, "mhash" => BookingCallback.hashize(bookable.timestamp_id)}}
  return req
end

describe ActsAsBookable do
  let(:bookable){BookableMock.new}

  it {expect(BookableMock.booking_callback(request(bookable))).to be_a BookingCallback}
  it {expect(bookable).to respond_to "params_hash"}
  it {expect(bookable.params_hash.keys).to eql [:form_id, :key, "Prix", :firstname, :surname, :address, :npa, :town, :country_iso, :email, :payment_type, :gross_amount, :nb_place, :uni_id, :no_fonds, :centre_couts, "SAP-LINK"]}
end
