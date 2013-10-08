class Category
  attr_reader :name, :fee, :details

  def initialize(data={})
    @name = data[:name]
    @fee = data[:fee]
    @details = data[:details]
  end

  def details_and_price
    "#{details}: #{fee} CHF"
  end
end
