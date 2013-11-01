ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
  :address => "outlook.unige.ch",
  :port => 587,
  :enable_starttls_auto => true,
  :user_name => 'genev',
  :password => 'bwxdc7',
  :authentication => :login
}
