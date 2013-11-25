class BookingCallback
  attr_reader :errors, :mhash, :controle_md5, :bookable_timestamp_id, :remote_addr, :uni_id, :key, :secret_key, :bookable

  def initialize(request, bookable_class)
    @uni_id = request.params['id']
    @bookable_timestamp_id = uni_id.gsub("#{ENV['BOOKING_FORM_ID']}-","")
    @mhash = request.params['mhash']
    @remote_addr = request.remote_ip
    @secret_key = ENV['BOOKING_SECRET_KEY']
    @key = uni_id.to_s+secret_key
    @controle_md5 = BookingCallback.hashize bookable_timestamp_id
    @bookable = bookable_class.where(timestamp_id: bookable_timestamp_id).first
    @errors = {}
  end

  def self.hashize(bookable_timestamp_id)
    Digest::MD5.hexdigest "#{ENV['BOOKING_FORM_ID']}-#{bookable_timestamp_id}#{ENV['BOOKING_SECRET_KEY']}"
  end

  def valid?
    begin
      _validate_mhash
      _validate_remote_addr
      bookable.present?
    rescue Exception => e
      Airbrake.notify(e)
    end
    errors.blank?
  end

  private

  def data
      {
        uni_id: uni_id,
        bookable_timestamp_id: bookable_timestamp_id,
        mhash: mhash,
        remote_addr: remote_addr,
        controle_md5: controle_md5
      }
    end

    def _validate_mhash
      if controle_md5 != mhash
        errors[:hash] = "is incorrect"
        raise "Hash is incorrect: #{data.inspect}"
      end
      true
    end

    def _validate_remote_addr
      booking_remote = ENV['BOOKING_REMOTE']
      if remote_addr != booking_remote
        errors[:remote_server] = "doesn't match"
        raise "Remote server is incorrect: #{data.inspect}"
      end
      true
    end
end
