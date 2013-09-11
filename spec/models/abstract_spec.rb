require 'spec_helper'

describe Abstract do
  it {should belong_to :registration}
  it {should validate_presence_of :title}
  it {should validate_presence_of :authors}
  it {should validate_presence_of :body}
end
