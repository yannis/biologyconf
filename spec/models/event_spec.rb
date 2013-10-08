require 'spec_helper'

describe Event do
  it {should validate_presence_of :title}
  it {should validate_presence_of :start}
  it {should validate_uniqueness_of :start}

  it {expect(Event.days).to eq []}

  context "with a few existing events spanning 2 day" do
    let!(:event1) {create :event, start: "2014-02-13 08:00"}
    let!(:event2) {create :event, start: "2014-02-14 08:00"}

    it {expect(event1.start).to be_a Time}

    it {expect(Event.days).to be_an Array}
    it {expect(Event.days).to eq [event1.start.to_date, event2.start.to_date]}
    it {expect(Event.for_day(Date.parse('2014-02-13'))).to eq [event1]}
    it {expect(Event.for_day(Date.parse('2014-02-14'))).to eq [event2]}
    it {expect(Event.for_day(Date.parse('2014-02-15'))).to eq []}
  end

  describe "the classes" do
    subject {create :event, classes: "bold grey", kind: "break"}
    its(:table_classes){should eq "bold grey event-break"}
  end
end
