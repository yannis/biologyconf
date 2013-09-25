class Booking

  attr_reader :registration, :form_id, :key, :params_hash

  URL = "https://booking.unige.ch/CT.aspx"

  def initialize(registration=nil)
    @registration = registration
    @form_id = "226"
    @key = "67C9BD2C6943CCD4377020C2ACE60762"
    @no_fonds = "S18078"
    @centre_couts = "229707"
    @params_hash = {
      form_id: @form_id,
      key: @key,
      "Prix" => @registration.category.fee,
      firstname: @registration.first_name,
      surname: @registration.last_name,
      address: @registration.address,
      npa: @registration.zip_code,
      town: @registration.city,
      country_iso: Country.find_country_by_name(@registration.country).alpha2,
      email: @registration.email,
      payment_type: 0,
      gross_amount: @registration.category.fee,
      nb_place: 1,
      uni_id: "#{@form_id}-#{@registration.id}",
      no_fonds: @centre_couts,
      centre_couts: @centre_couts,
      "SAP-LINK" => "PRD"
    }
  end

  def params_string
    self.params_hash.map{|k,v| "#{k}=#{v}"}.join('&')
  end

  def url
    "#{URL}?#{params_string}"
  end

  def send_data
    Net::HTTP.post_form(URI.parse(URL), self.params_hash)
  end
end
