Airbrake.configure do |config|
  config.development_environments = []
  config.api_key = ENV['AIRBRAKE_API_KEY']
end
