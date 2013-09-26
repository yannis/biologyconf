class Registration < ActiveRecord::Base

  attr_reader 'abstract_disabled'

  CATEGORIES = [
    {name: "non_member", details: "Non-member (student or researcher)", fee: (Rails.env.production? ? 50 : 0.10)},
    {name: "student_member", details: "Master or PhD student, full member (SZS, SSS, or SBS)", fee: 20},
    {name: "advanced_member", details: "Advanced researcher, full member (SZS, SSS, or SBS)", fee: 30}
  ]

  validates_presence_of :first_name, :last_name, :email, :institute, :address, :zip_code, :city, :country, :category_name
  validates_uniqueness_of :last_name, :scope => :first_name
  validates_uniqueness_of :email
  validates_inclusion_of :category_name, in: CATEGORIES.map{|c| c[:name]}, allow_nil: false

  validates_presence_of :title, if: Proc.new{|r| r.authors.present?}
  validates_presence_of :authors, if: Proc.new{|r| r.title.present?}
  validates_presence_of :body, if: Proc.new{|r| r.title.present?}

  before_create :set_id_token

  def self.categories
    CATEGORIES.map{|ch| Category.new ch}
  end

  def abstract_disabled
    [self.title, self.authors, self.body, self.talk].compact.blank?
  end

  def category
    Registration.categories.detect{|c| c.name == self.category_name}
  end

  def booking
    Booking.new self
  end

  def mark_as_paid
    update_attributes paid: true
  end

  protected

    def generate_personal_token
      Digest::SHA1.hexdigest(Time.now.to_s + self.id.to_s)
    end

  private

    def set_id_token
      self.id_token = self.generate_personal_token if self.respond_to?(:id_token) && self.id_token.blank?
    end
end
