class Speaker < ActiveRecord::Base

  TITLE = ["Mr", "Ms", "Dr.", "Prof."]

  has_attached_file :portrait, :styles => { :s300 => "300x300>", :s200 => "200x200>", :s100 => "100x100>", :thumb => "100x100" }

  validates_presence_of :first_name, :last_name
  validates_uniqueness_of :last_name, :scope => :first_name
  validates_inclusion_of :title, in: TITLE, allow_nil: true

  def full_name
    [title, first_name, last_name].compact.join(' ')
  end
end
