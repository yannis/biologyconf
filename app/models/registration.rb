require 'acts_as_bookable'
class Registration < ActiveRecord::Base

  CATEGORIES = [
    {name: "non_member", details: "non-member (student or researcher)", fee: (Rails.env.production? ? 50 : 0.10)},
    {name: "student_member", details: "master or PhD student, member <a href='http://ssz.scnatweb.ch/en/' target='_blank'>SZS</a>, <a href='http://www.swiss-systematics.ch/' target='_blank'>SSS</a>, or <a href='http://www.botanica-helvetica.ch/index.fr.php' target='_blank'>SBS</a>", fee: 25},
    {name: "advanced_member", details: "advanced researcher, member <a href='http://ssz.scnatweb.ch/en/' target='_blank'>SZS</a>, <a href='http://www.swiss-systematics.ch/' target='_blank'>SSS</a>, or <a href='http://www.botanica-helvetica.ch/index.fr.php' target='_blank'>SBS</a>", fee: 35}
  ]

  DINNER_CATEGORIES = [
    {name: "student", details: "student", fee: 30},
    {name: "non_student", details: "non-student", fee: 55}
  ]

  DORMITORY_FEE = 26

  POSTER_DEADLINE = Time.parse("2014-01-14 23:59")
  DORMITORY_CAPACITY = 50
  REGISTRATION_DEADLINE = Time.parse("2014-02-07 23:59")

  acts_as_bookable

  validates_presence_of :institute, :category_name # other presence validation taken in charge by the acts_as_bookable module
  validates_inclusion_of :category_name, in: CATEGORIES.map{|c| c[:name]}, allow_nil: false
  validates_inclusion_of :dinner_category_name, in: DINNER_CATEGORIES.map{|c| c[:name]}, allow_blank: true
  validates_presence_of :title, if: Proc.new{|r| r.abstract?}
  validates_presence_of :authors, if: Proc.new{|r| r.abstract?}
  validates_presence_of :body, if: Proc.new{|r| r.abstract?}

  before_validation :_sanitize_abstract_body
  after_create :_set_id_token, :_set_timestamp_id

  def self.categories
    CATEGORIES.map{|ch| Category.new ch}
  end

  def self.dinner_categories
    DINNER_CATEGORIES.map{|ch| Category.new ch}
  end

  def self.dormitory_full?
    where(paid: true, dormitory: true).count >= DORMITORY_CAPACITY
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def category
    Registration.categories.detect{|c| c.name == self.category_name}
  end

  def dinner_category
    Registration.dinner_categories.detect{|c| c.name == self.dinner_category_name}
  end

  def fee
    fee = 0
    fee += self.category.try(:fee).to_f
    fee += self.dinner_category.try(:fee).to_f
    fee += DORMITORY_FEE if self.dormitory?
    fee
  end

  def abstract?
    self.talk.present? || self.title.present? || self.authors.present? || self.body.present?
  end

  protected

    def generate_personal_token
      Digest::SHA1.hexdigest(Time.now.to_s + self.id.to_s)
    end

  private

    def _set_id_token
      self.update_attributes(id_token: self.generate_personal_token) if self.respond_to?(:id_token) && self.id_token.nil?
    end

    def _set_timestamp_id
      self.update_attributes timestamp_id: "#{self.created_at.to_i}#{self.id}"
    end

    def _sanitize_abstract_body
      self.body = ActionController::Base.helpers.sanitize(self.body , tags: %w(i b h1 h2 p ul ol li), attributes: %w())
    end
end
