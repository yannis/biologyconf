class Registration < ActiveRecord::Base

  CATEGORY = [
    {name: "non_member", details: "Non-member (student or researcher)", fee: 50},
    {name: "student_member", details: "Master or PhD student, full member (SZS, SSS, or SBS)", fee: 20},
    {name: "advanced_member", details: "Advanced researcher, full member (SZS, SSS, or SBS)", fee: 30}
  ]

  has_one :abstract, :dependent => :destroy
  validates_presence_of :first_name, :last_name, :email, :institute, :address, :zip_code, :city, :country, :category
  validates_uniqueness_of :last_name, :scope => :first_name
  validates_uniqueness_of :email
  validates_inclusion_of :category, in: CATEGORY.map{|c| c[:name]}, allow_nil: false

  accepts_nested_attributes_for :abstract
  validates_associated :abstract, if: Proc.new { |registration| registration.abstract && registration.abstract.disabled }

  def self.categories
    CATEGORY.map{|ch| Category.new ch}
  end
end
