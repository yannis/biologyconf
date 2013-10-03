class BookingCallback

  attr_reader :errors, :mhash, :controle_md5, :registration_id, :remote_addr, :uni_id, :key, :secret_key

  def self.hashize(key)
    Digest::MD5.hexdigest key
   end

  def initialize(request)
    # p "request.remote_ip: #{request.remote_ip}"
    @uni_id = request.params['id']
    @registration_id = uni_id.gsub("#{ENV['BOOKING_FORM_ID']}-","")
    @mhash = request.params['mhash']
    @remote_addr = request.remote_ip
    @secret_key = ENV['BOOKING_SECRET_KEY']
    @key = uni_id.to_s+secret_key
    @controle_md5 = BookingCallback.hashize key
    @errors = {}
  end

  def data
    {
      uni_id:       uni_id,
      mhash:        mhash,
      remote_addr:  remote_addr,
      key:          key,
      controle_md5: controle_md5
    }
  end

  def registration
    Registration.find registration_id
  end

  def valid?
    begin
      _validate_mhash
      _validate_remote_addr
      registration.present?
    rescue Exception => e
      Airbrake.notify(e)
    end
    errors.blank?
  end

  private

    def _validate_mhash
      if controle_md5 != mhash
        errors[:hash] = "is incorrect"
        raise "Hash is incorrect: #{data.inspect}"
      end
    end

    def _validate_remote_addr
      booking_remote = ENV['BOOKING_REMOTE']
      if remote_addr != booking_remote
        errors[:remote_server] = "doesn't match"
        raise "Remote server is incorrect: #{data.inspect}"
      end
    end
end
