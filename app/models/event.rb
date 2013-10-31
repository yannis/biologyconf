class Event < ActiveRecord::Base


  TYPE = ['organisation', 'student presentation', 'keynote presentation', 'break']

  validates_presence_of :title
  validates_presence_of :start
  validates_uniqueness_of :start
  validates_inclusion_of :kind, in: TYPE, allow_nil: true

  def self.days
    select(:start).uniq.map{|e| e.start.to_date}.uniq
  end

  def self.for_day(day)
    where("DATE(events.start) = ?", day)
  end

  def table_classes
    c = [self.classes] << case self.kind
                          when "break" then "event-break"
                          when "organisation" then "event-organisation"
                          when "keynote presentation" then "event-keynote"
                          else nil
                          end
    c.compact.present? ? c.join(' ') : nil
  end
end
