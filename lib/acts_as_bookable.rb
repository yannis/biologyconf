module ActsAsBookable

  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def acts_as_bookable
      include InstanceMethods
      validates_presence_of :first_name, :last_name, :email, :address, :zip_code, :city, :country
      validates_uniqueness_of :last_name, if: Proc.new{|r| Registration.where(last_name: r.last_name, first_name: r.first_name, paid: true).count > 0 }, message: "A paid registration for “%{value}” already exist"
    end

    def booking_callback(request)
      BookingCallback.new(request, self)
    end
  end

  module InstanceMethods

    def form_id
      ENV['BOOKING_FORM_ID']
    end

    def key
      ENV["BOOKING_KEY"]
    end

    def uni_id
      "#{form_id}-#{timestamp_id}"
    end

    def no_fonds
      ENV['BOOKING_NO_FONDS']
    end

    def centre_couts
      ENV['BOOKING_CENTRE_COUTS']
    end

    def params_hash
      {
        form_id: form_id,
        key: key,
        "Prix" => fee,
        firstname: first_name,
        surname: last_name,
        address: address,
        npa: zip_code,
        town: city,
        country_iso: Country.find_country_by_name(country).alpha2,
        email: email,
        payment_type: 0,
        gross_amount: fee,
        nb_place: 1,
        uni_id: uni_id,
        no_fonds: no_fonds,
        centre_couts: centre_couts,
        "SAP-LINK" => "PRD"
      }
    end

    def first_name
      super
    end

    def last_name
      super
    end

    def email
      super
    end

    def address
      super
    end

    def zip_code
      super
    end

    def city
      super
    end

    def country
      super
    end

    def fee
      super
    end

    def paid
      super
    end

    def timestamp_id
      super
    end

    def mark_as_paid
      update_attributes paid: true, paid_fee: fee
    end

  end
end

ActiveRecord::Base.send(:include, ActsAsBookable) if ActiveRecord
