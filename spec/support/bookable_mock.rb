require 'acts_as_bookable'

class BookableMock
  include ActiveModel::Validations
  include ActiveRecord::Validations
  include ActsAsBookable
  acts_as_bookable

  def self.where(params)
    [self.new]
  end

  def id
    1
  end

  def timestamp_id
    "123456789"
  end

  def first_name
    "first_name"
  end

  def last_name
    "last_name"
  end

  def address
    "street_address"
  end

  def zip_code
    "zip_code"
  end

  def city
    "city"
  end

  def country
    "Switzerland"
  end

  def email
    "email"
  end

  def fee
    0
  end

  def timestamp_id
    "1234567891"
  end
end
