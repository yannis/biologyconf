class HomeController < ApplicationController
  def show
    @registration = Registration.new(abstract: Abstract.new)
    @abstract = @registration.abstract
    @grouped_events = Event.order(:start).group_by{|e| e.start.to_date}
  end
end
