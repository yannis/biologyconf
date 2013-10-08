require 'spec_helper'

describe Registration do
  it {should validate_presence_of :first_name}
  it {should validate_presence_of :last_name}
  # it {should validate_uniqueness_of(:last_name)}
  it {should validate_presence_of :email}
  it {should validate_presence_of :institute}
  it {should validate_presence_of :category_name}
  it {should ensure_inclusion_of(:category_name).in_array(Registration.categories.map(&:name))}

  it{expect(Registration.categories.count).to eq 3}
  it{expect(Registration.categories.first).to be_a Category}
  it{expect(Registration.dinner_categories.count).to eq 2}
  it{expect(Registration.dinner_categories.first).to be_a Category}
end

describe "A registration" do
  let(:registration) { create :registration}
  it {expect(registration.category).to be_a Category}
  it {expect(registration.category_name).to eq "non_member"}
  it {expect(registration.fee).to eq 0.1}
  it {expect(registration.paid_fee.to_f).to eq 0}

  describe "when mark as paid" do
    before {registration.mark_as_paid}
    it {expect(registration).to be_paid}
    it {expect(registration.paid_fee.to_f).to eq 0.1}
  end

  describe "when category_name is 'advanced_member'" do
    before {registration.update_attributes category_name: 'advanced_member'}
    it {expect(registration.fee).to eq 30.0}
    it {expect(registration.paid_fee.to_f).to eq 0}

    describe "when mark as paid" do
      before {registration.mark_as_paid}
      it {expect(registration).to be_paid}
      it {expect(registration.paid_fee.to_f).to eq 30}
    end

    describe "when dinner_category_name is 'non_member'" do
      before {registration.update_attributes dinner_category_name: 'non_student'}
      it{expect(registration).to be_valid_verbose}
      it {expect(registration.dinner_category.name).to eq 'non_student'}
      it {expect(registration.fee).to eq 90.0}
      it {expect(registration.paid_fee.to_f).to eq 0}

      describe "when mark as paid" do
        before {registration.mark_as_paid}
        it {expect(registration.paid_fee.to_f).to eq 90}
      end

      describe "when dormitory is true" do
        before {registration.update_attributes dormitory: true}
        it{expect(registration).to be_valid_verbose}
        it {expect(registration.fee).to eq 112.0}
        it {expect(registration.paid_fee.to_f).to eq 0}

        describe "when mark as paid" do
          before {registration.mark_as_paid}
          it {expect(registration).to be_paid}
          it {expect(registration.paid_fee.to_f).to eq 112.0}
        end
      end
    end
  end
end


describe "validation of last name" do
  context "if an unpaid registration with same last_name and first_name already exists" do
    let!(:registration){create :registration, paid: false}
    let(:registration2){ build :registration, first_name: registration.first_name, last_name: registration.last_name }
    it {expect(registration).to be_valid_verbose}
    it {expect(registration2).to be_valid_verbose}
  end
  context "if a paid registration with same last_name and first_name already exists" do
    let!(:registration){create :registration, paid: true}
    let(:registration2){ build :registration, first_name: registration.first_name, last_name: registration.last_name }
    it {expect(registration).to be_valid_verbose}
    it {expect(registration2).to_not be_valid}
    it {
      registration2.valid?
      expect(registration2.errors[:last_name]).to include "A paid registration for “#{registration2.last_name}” already exist"
    }
  end
end
