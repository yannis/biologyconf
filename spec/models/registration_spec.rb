require 'spec_helper'

describe Registration do
  it {should have_one( :abstract).dependent(:destroy)}
  it {should validate_presence_of :first_name}
  it {should validate_presence_of :last_name}
  it {should validate_uniqueness_of(:last_name).scoped_to(:first_name)}
  it {should validate_presence_of :email}
  it {should validate_presence_of :institute}
end
