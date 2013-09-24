class Booking

  attr_reader :registration

  URL = "https://cms.unige.ch/webtools/static/booking/946335/index.php"

  def initialize(data={})
    @registration = data[:registration] || Registration.new

  end

  def url
    URL
  end
end
