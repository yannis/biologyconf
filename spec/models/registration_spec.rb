require 'spec_helper'

describe Registration do
  it {should validate_presence_of :first_name}
  it {should validate_presence_of :last_name}
  it {should validate_uniqueness_of(:last_name).scoped_to(:first_name)}
  it {should validate_presence_of :email}
  it {should validate_presence_of :institute}
  it {should validate_presence_of :category_name}
  it {should ensure_inclusion_of(:category_name).in_array(Registration.categories.map(&:name))}

  it{expect(Registration.categories.count).to eq 3}
  it{expect(Registration.categories.first).to be_a Category}
end

describe "A registration" do
  let(:registration) { create :registration, category_name: "non_member"}
  it {expect(registration.category).to be_a Category}
  describe "when mark as paid" do
    before {registration.mark_as_paid}
    it {expect(registration).to be_paid}
  end
end
