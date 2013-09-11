class Abstract < ActiveRecord::Base

  belongs_to :registration

  validates_presence_of :title
  validates_presence_of :authors
  validates_presence_of :body
end
