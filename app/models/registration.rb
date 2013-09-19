class Registration < ActiveRecord::Base

  CATEGORY = {}

  has_one :abstract, :dependent => :destroy
  # validates :first_name, presence: {message: 'kjhskdfkdfhdfkh'}
  validates_presence_of :first_name, :last_name, :email, :institute, :address, :zip_code, :city, :country
  validates_uniqueness_of :last_name, :scope => :first_name
  validates_uniqueness_of :email

  accepts_nested_attributes_for :abstract
  validates_associated :abstract, if: Proc.new { |registration| registration.abstract && registration.abstract.disabled }
end
