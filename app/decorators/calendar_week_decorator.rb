# Take an array of events and returns an array that knows how many events are "

class CalendarWeekDecorator < Draper::Decorator
  Day = Struct.new(:name, :events)
  DAYS = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]

  delegate_all

  def days
    @days ||= DAYS.map { |d| Day.new(d, events_for(d)) }
  end

  private

    def events_for(day_name)
      object.find_all { |o| o[:day] == day_name }
    end
end
