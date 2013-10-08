class Booking

  attr_reader :registration, :params_hash, :form_id, :uni_id

  def initialize(registration=nil)
    @registration = registration
    @form_id = ENV['BOOKING_FORM_ID']
    @uni_id = "#{@form_id}-#{@registration.id_token}"
    @params_hash = {
      form_id: @form_id,
      key: ENV['BOOKING_FORM_KEY'],
      "Prix" => @registration.fee,
      firstname: @registration.first_name,
      surname: @registration.last_name,
      address: @registration.address,
      npa: @registration.zip_code,
      town: @registration.city,
      country_iso: Country.find_country_by_name(@registration.country).alpha2,
      email: @registration.email,
      payment_type: 0,
      gross_amount: @registration.fee,
      nb_place: 1,
      uni_id: @uni_id,
      no_fonds: ENV['BOOKING_NO_FONDS'],
      centre_couts: ENV['BOOKING_CENTRE_COUTS'],
      "SAP-LINK" => "PRD"
    }
  end
end
