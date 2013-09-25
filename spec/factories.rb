FactoryGirl.define do
  # define an incremental username
  sequence :name do |n|
    n.to_s
  end

  sequence :integer do |n|
    n
  end
  factory :event do
    title { 'student presentation' }
    start { "2014-02-13 10:00"}
    self.end {|e| Time.parse(e.start)+15}
    kind { 'student presentation' }
  end

  factory :registration do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.email }
    category_name {"non_member"}
    institute {Faker::Company.name}
    address {Faker::Address.street_address}
    zip_code {Faker::Address.zip_code}
    city {Faker::Address.city}
    country {Faker::Address.country}
    title { Faker::Lorem.sentence }
    authors { Faker::Name.name }
    body { "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. " }
  end

  factory :category do
    name { Faker::Company.name }
    fee { generate :integer }
    details { "Lorem ipsum dolor sit amet" }
  end

  # sequence :user_email do |n|
  #   "email_#{n}@email.com"
  # end

  # factory :category do |i|
  #   i.name { 'cat_'+FactoryGirl.generate(:name) }
  #   i.description 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.'
  #   i.color   Random::DEFAULT.rand(999999).to_s
  #   i.acronym { 'acro_'+FactoryGirl.generate(:name) }
  # end

  # factory :document do |i|
  #   # i.attach  :data, "/test/fixtures/files/30_278_H.pdf", "application/pdf"
  #   i.data File.new("#{Rails.root}/spec/support/files/a_pdf.pdf")
  #   i.association :model, :factory => :seminar
  # end

  # factory :host do
  #   name {"#{Faker::Name.first_name} #{Faker::Name.last_name}".to_s}
  #   email {Faker::Internet.email}
  # end

  # factory :hosting do |i|
  #   i.association :host
  #   i.association :seminar
  # end

  # factory :speaker do |i|
  #   i.name { 'speaker_'+FactoryGirl.generate(:name) }
  #   i.affiliation { 'affiliation_'+FactoryGirl.generate(:name) }
  #   i.title { 'title_'+FactoryGirl.generate(:name) }
  # end

  # factory :building do
  #   name { 'building_'+FactoryGirl.generate(:name) }
  # end

  # factory :location do
  #   name {'location_'+FactoryGirl.generate(:name)}
  #   association :building
  # end

  # factory :picture do
  #   data_file_name { "picture.jpg" }
  #   data_content_type { 'image/jpg' }
  #   data_file_size { 1024 }
  #   association :model, :factory => :seminar
  # end

  # factory :seminar do |s|
  #   s.title { 'seminar_'+FactoryGirl.generate(:name) }
  #   s.association :category
  #   s.association :location
  #   s.association :user
  #   s.speakers{ |a| [a.association(:speaker)]}
  #   s.hostings {[FactoryGirl.build(:hosting, seminar_id: nil)]}
  #   # s.hostings_attributes {{:one => {:host_id => FactoryGirl.create(:host).id}}}
  #   s.start_on{ 2.weeks.since}
  # end

  # # factory :seminar_with_hostings, :parent => :seminar do |i|
  # #   i.after_build { |a| Factory(:hosting, :seminar => a)}
  # # end

  # factory :user do |u|
  #   name {"#{Faker::Name.first_name} #{Faker::Name.last_name}".to_s}
  #   email {Faker::Internet.email}
  #   password {'password_'+FactoryGirl.generate(:name)}
  #   password_confirmation {|a| a.password}
  #   authentication_token {|a| generate(:name) }
  # end
end
