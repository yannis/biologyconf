require 'spec_helper'

def request(registration)
  id = "226-#{registration.id}"
  req = Object.new
  req.stub(:remote_ip){"0.0.0.0"}
  req.stub(:params){{"id" => id, "mhash" => BookingCallback.hashize("#{id}#{ENV['BOOKING_SECRET_KEY']}")}}
  return req
end

def bad_remote_request(registration)
  id = "226-#{registration.id}"
  req = Object.new
  req.stub("remote_ip"){"1.1.1.1"}
  req.stub(:params){{"id" => id, "mhash" => BookingCallback.hashize("#{id}#{ENV['BOOKING_SECRET_KEY']}")}}
  return req
end

def bad_hash_request(registration)
  id = "226-#{registration.id}"
  req = Object.new
  req.stub(:remote_ip){"0.0.0.0"}
  req.stub(:params){{"id" => id, "mhash" => "ghjfghjfghdfsghdfgh554545665"}}
  return req
end

describe BookingCallback do
  it {expect(BookingCallback.hashize("justatest")).to eq "83bb7355a52055b3e3990550064555e4"}
end

describe "A booking callback with a valid request" do
  let(:registration){create :registration}
  let(:booking_callback){BookingCallback.new request(registration)}
  it { expect(booking_callback).to be_valid_verbose }
  it { expect(booking_callback.registration).to eq registration }
end

describe "A booking callback with a request with invalid remote" do
  let(:registration){create :registration}
  let(:booking_callback){BookingCallback.new bad_remote_request(registration)}
  it { expect(booking_callback).to_not be_valid }
  it {
    booking_callback.valid?
    expect(booking_callback.errors[:remote_server]).to eq "doesn't match"
  }
end

describe "A booking callback with a request with invalid hash" do
  let(:registration){create :registration}
  let(:booking_callback){BookingCallback.new bad_hash_request(registration)}
  it { expect(booking_callback).to_not be_valid }
  it {
    booking_callback.valid?
    expect(booking_callback.errors[:hash]).to eq "is incorrect"
  }
end
