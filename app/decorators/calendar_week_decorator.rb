# Take an array of events and returns an array that knows how many events are "

class CalendarWeekDecorator < Draper::Decorator
  Day = Struct.new(:name)
  DAYS = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]

  delegate_all

  def days
    @days ||= DAYS.map { |d| Day.new(d) }
  end
end
