ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require "email_spec"
require 'capybara/rspec'
require 'capybara/rails'
require 'capybara-screenshot/rspec'
require "paperclip/matchers"
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
  config.include Paperclip::Shoulda::Matchers
  config.include(EmailSpec::Helpers)
  config.include(EmailSpec::Matchers)
  # config.include Warden::Test::Helpers
  # Warden.test_mode!

  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.order = 'random'

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.use_transactional_fixtures = false

  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
    system("rm -rf #{Rails.root.join("tmp/capybara/*")}")
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

  def should_be_asked_to_sign_in
    it {response.should redirect_to(new_user_session_path)}
    it {flash[:alert].should =~ /Please sign in/}
  end

  def should_not_be_authorized
    it {response.should redirect_to(root_path)}
    it {flash[:alert].should =~ /You are not authorized to access this page/}
  end

  def signin(user)
    visit '/users/sign_in'
    if has_selector?("form#new_user[action='/users/sign_in']")
       # current_path == '/users/sign_in'
      fill_in "user_email", :with => user.email
      fill_in "user_password", :with => user.password
      click_button :user_submit
    end
    # page.should have_content('Signed in successfully.')
  end

  def signin_and_visit(user, url)
    login_as user, :scope => :user
    visit url
    # visit url
    # if page.has_selector?("form#new_user[action='/users/sign_in']")
    #   fill_in "user_email", :with => user.email
    #   fill_in "user_password", :with => user.password
    #   click_button :user_submit
    #   visit url
    # end
  end

  def flash_should_contain(text)
    page.find("div#flash").should have_content text
  end
end
