shared_examples_for "a bookable" do
  it {should validate_presence_of :first_name}
  it {should validate_presence_of :last_name}
  it {should validate_presence_of :email}
  it {should respond_to :address}
  it {should respond_to :city}
  it {should respond_to :zip_code}
  it {should respond_to :country}
  it {should respond_to :paid}
  it {should respond_to :fee}
  it {should respond_to :timestamp_id}
end
