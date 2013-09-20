class Category
  attr_reader :name, :fee, :details

  def initialize(data={})
    @name = data[:name]
    @fee = data[:fee]
    @details = data[:details]
  end

end
