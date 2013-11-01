require 'spec_helper'

describe Registration do
  it_behaves_like "a bookable"

  it {expect(Registration::POSTER_DEADLINE).to be_a Time}
  it {expect(Registration::REGISTRATION_DEADLINE).to be_a Time}
  # it {should validate_uniqueness_of(:last_name)}
  it {should validate_presence_of :institute}
  it {should validate_presence_of :category_name}
  it {should ensure_inclusion_of(:category_name).in_array(Registration.categories.map(&:name))}

  it {expect(Registration.categories.count).to eq 3}
  it {expect(Registration.categories.first).to be_a Category}
  it {expect(Registration.dinner_categories.count).to eq 2}
  it {expect(Registration.dinner_categories.first).to be_a Category}
end

describe "A registration" do

  let(:registration) { build :registration}
  it {expect(registration.category).to be_a Category}
  it {expect(registration.category_name).to eq "non_member"}
  it {expect(registration.fee).to eq 0.1}
  it {expect(registration.paid_fee.to_f).to eq 0}
  it {expect(registration.abstract?).to_not be_true}
  it {
    Timecop.freeze("2013-11-01 14:00:00")
    registration.save
    expect(registration.reload.timestamp_id).to eq "13833108001"
    Timecop.return
  }

  describe "when mark as paid" do
    before {registration.mark_as_paid}
    it {expect(registration).to be_paid}
    it {expect(registration.paid_fee.to_f).to eq 0.1}
  end

  describe "when category_name is 'advanced_member'" do
    before {registration.update_attributes category_name: 'advanced_member'}
    it {expect(registration.fee).to eq 35.0}
    it {expect(registration.paid_fee.to_f).to eq 0}

    describe "when mark as paid" do
      before {registration.mark_as_paid}
      it {expect(registration).to be_paid}
      it {expect(registration.paid_fee.to_f).to eq 35}
    end

    describe "when dinner_category_name is 'non_member'" do
      before {registration.update_attributes dinner_category_name: 'non_student'}
      it {expect(registration).to be_valid_verbose}
      it {expect(registration.dinner_category.name).to eq 'non_student'}
      it {expect(registration.fee).to eq 90.0}
      it {expect(registration.paid_fee.to_f).to eq 0}

      describe "when mark as paid" do
        before {registration.mark_as_paid}
        it {expect(registration.paid_fee.to_f).to eq 90}
      end

      describe "when dormitory is true" do
        before {registration.update_attributes dormitory: true}
        it {expect(registration).to be_valid_verbose}
        it {expect(registration.fee).to eq 116.0}
        it {expect(registration.paid_fee.to_f).to eq 0}

        describe "when mark as paid" do
          before {registration.mark_as_paid}
          it {expect(registration).to be_paid}
          it {expect(registration.paid_fee.to_f).to eq 116.0}
        end
      end
    end
  end
end

describe "#dormitory_full" do
  context "with already 49 paid dormitory registrations" do
    before {
      49.times do
        create :registration, paid: true, dormitory: true
      end
    }
    it {expect(Registration.dormitory_full?).to be_false}

    context "when one more paid dormitory registration is created" do
      before {create :registration, paid: true, dormitory: true}
      it {expect(Registration.dormitory_full?).to be_true}
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

describe "validation of abstract:" do
  context "a registration with incomplete abstract" do
    let(:registration){build :registration, talk: true}
    it {expect(registration.abstract?).to be_true}
    it {expect(registration).to_not be_valid}
    it {expect(registration).to have_errors_on :title}
    it {
      registration.valid?
      expect(registration.errors[:title]).to include "can't be blank"
      expect(registration.errors[:authors]).to include "can't be blank"
      expect(registration.errors[:body]).to include "can't be blank"
    }
  end
end

describe "body sanitization:" do
  context "a registration with blacklisted tags in its body" do
    let(:registration) { create :registration, :abstract, body: "<h3>h3</h3> <strong>strong</strong> <i>i</i>  <i class='paf'>i with class att</i> <b>b</b>" }
    it "is sanitized" do
      expect(registration.body).to eq "h3 strong <i>i</i>  <i>i with class att</i> <b>b</b>"
    end
  end
end
