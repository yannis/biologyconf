require 'spec_helper'

describe Speaker do
  it {should validate_presence_of :first_name}
  it {should validate_presence_of :last_name}
  it {should validate_uniqueness_of(:last_name).scoped_to(:first_name)}
  it {should ensure_inclusion_of(:title).in_array(Speaker::TITLE)}
  it { should have_attached_file(:portrait) }
end

describe "a speaker" do
  subject{create :speaker, first_name: 'Lars', last_name: 'Von Trier', title: "Prof."}
  its(:full_name) {should eql "Prof. Lars Von Trier"}
end
