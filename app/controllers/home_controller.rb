class HomeController < ApplicationController
  def show
    @registration = Registration.new(abstract: Abstract.new, category: "non_member")
    @grouped_events = Event.order(:start).group_by{|e| e.start.to_date}
    @speakers = Speaker.order(:last_name, :first_name)
  end
end
