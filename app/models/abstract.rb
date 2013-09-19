class Abstract < ActiveRecord::Base

  attr_reader 'disabled'

  belongs_to :registration

  validates_presence_of :title
  validates_presence_of :authors
  validates_presence_of :body

  def disabled
    self.attributes.values.compact.blank?
  end
end
