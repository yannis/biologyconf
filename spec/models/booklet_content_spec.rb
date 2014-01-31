require 'spec_helper'

describe BookletContent do
  it {should validate_presence_of :identifier}
  it {should validate_uniqueness_of :identifier}
end
