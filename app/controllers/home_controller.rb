class HomeController < ApplicationController
  def show
    @registration = Registration.new(category_name: "non_member", country: "Switzerland")
    @grouped_events = Event.order(:start).group_by{|e| e.start.to_date}
    @speakers = Speaker.order(:last_name, :first_name)
    @countries = (Country.find_all_countries_by_subregion('Northern America')+Country.find_all_countries_by_region('Europe')).uniq.sort_by(&:name)
  end
end
