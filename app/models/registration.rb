class Registration < ActiveRecord::Base
  has_one :abstract, :dependent => :destroy
  validates_presence_of :first_name
  validates_presence_of :last_name
  validates_uniqueness_of :last_name, :scope => :first_name
  validates_presence_of :email
  validates_uniqueness_of :email
  validates_presence_of :institute

  accepts_nested_attributes_for :abstract
  validates_associated :abstract
end
