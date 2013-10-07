class Registration < ActiveRecord::Base

  attr_reader 'abstract_disabled'

  CATEGORIES = [
    {name: "non_member", details: "Non-member (student or researcher)", fee: (Rails.env.production? ? 50 : 0.10)},
    {name: "student_member", details: "Master or PhD student, member <a href='http://ssz.scnatweb.ch/en/' target='_blank'>SZS</a>, <a href='http://www.swiss-systematics.ch/' target='_blank'>SSS</a>, or <a href='http://www.botanica-helvetica.ch/index.fr.php' target='_blank'>SBS</a>", fee: 20},
    {name: "advanced_member", details: "Advanced researcher, member <a href='http://ssz.scnatweb.ch/en/' target='_blank'>SZS</a>, <a href='http://www.swiss-systematics.ch/' target='_blank'>SSS</a>, or <a href='http://www.botanica-helvetica.ch/index.fr.php' target='_blank'>SBS</a>", fee: 30}
  ]

  validates_presence_of :first_name, :last_name, :email, :institute, :address, :zip_code, :city, :country, :category_name
  validates_uniqueness_of :last_name, if: Proc.new{|r| Registration.where(last_name: r.last_name, first_name: r.first_name, paid: true).count > 0 }, message: "A paid registration for “%{value}” already exist"
  validates_inclusion_of :category_name, in: CATEGORIES.map{|c| c[:name]}, allow_nil: false
  validates_presence_of :title, if: Proc.new{|r| r.authors.present? || r.body.present?}
  validates_presence_of :authors, if: Proc.new{|r| r.title.present? || r.body.present?}
  validates_presence_of :body, if: Proc.new{|r| r.title.present? || r.authors.present?}

  before_create :set_id_token

  def self.categories
    CATEGORIES.map{|ch| Category.new ch}
  end

  def full_name
    "#{first_name} #{last_name}"
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
