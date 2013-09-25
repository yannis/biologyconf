require 'spec_helper'

describe Booking do
  let(:registration){create :registration}
  let(:booking){Booking.new(registration)}
  it {expect(booking).to respond_to "registration"}
  it {expect(booking).to respond_to "url"}
  it {expect(booking.url).to eq "lkjfkdljfd"}
end
