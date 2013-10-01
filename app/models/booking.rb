class Booking

  attr_reader :registration, :params_hash, :form_id, :uni_id
  # attr:check_callback

  URL = "https://booking.unige.ch/CT.aspx"
  KEY = "67C9BD2C6943CCD4377020C2ACE60762"
  SECRET_KEY = "zrL$\\Rp5ImNsFWO,jv4THJ=@+Qn;t:(*|]!!2jf#.t"
  FORM_ID = "226"

  def initialize(registration=nil)
    no_fonds = "S18078"
    centre_couts = "229707"

    @registration = registration
    @form_id = FORM_ID
    @uni_id = "#{@form_id}-#{@registration.id}"
    @params_hash = {
      form_id: @form_id,
      key: KEY,
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
      uni_id: @uni_id,
      no_fonds: centre_couts,
      centre_couts: centre_couts,
      "SAP-LINK" => "PRD"
    }
  end

  def self.check_callback(request)
    my = request.params['my']
    test = request.params['test']
    uni_id = request.params['id']
    hash = request.params['hash']
    mhash = request.params['mhash']
    remote_addr = request.remote_ip
    uri = request.original_url

    secret_key = SECRET_KEY
    if Rails.env.test?
      goodRemote = "0.0.0.0"
    elsif Rails.env.development?
      goodRemote = "127.0.0.1"
    elsif Rails.env.staging? || Rails.env.production?
      goodRemote = "193.111.202.14"
    end

    cle = secret_key+uni_id.to_s

    controle_sha256 = Digest::SHA256.hexdigest cle
    controle_md5 = Digest::MD5.hexdigest cle

    data = {
      uri:              uri,
      my:               my,
      test:             test,
      uni_id:           uni_id,
      hash:             hash,
      mhash:            mhash,
      remote_addr:      remote_addr,
      cle:              cle,
      controle_md5:     controle_md5,
      controle_sha256:  controle_sha256
    }

    if mhash != controle_md5
      exception = "BookingCallbackError: HASH INCORRECT! #{data.inspect}"
      # notify_airbrake(exception)
      raise exception
      return false
    elsif remote_addr != goodRemote
      exception = "BookingCallbackError: SERVER INCORRECT! #{data.inspect}"
      # notify_airbrake(exception)
      raise exception
      return false
    else
      id = uni_id.gsub("#{FORM_ID}-","")
      return Registration.find id
    end
  end
end
