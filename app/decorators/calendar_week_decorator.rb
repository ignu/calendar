# Take an array of events and returns an array that knows how many events are "
class CalendarWeekDecorator < Draper::Decorator
  # We could get clever with #at_beginning_of_week, but this isn't likely to change
  # so is fine to hard code.
  DAYS = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]

  class Day
    attr_accessor :name, :events

    def initialize(name: name, events: events)
      self.name = name
      self.events = events
    end

    private

      def order_events
      end
  end

  class Event
    attr_accessor :class_name, :name, :options, :others

    def initialize(options)
      self.name = options[:name]
      self.options = options
      self.others = 0
    end

    def class_name
      "start-#{start_time} length-#{duration} others-0".gsub(/:/, "")
    end

    private

      def start_time
        options[:start_time]
      end

      def end_time
        options[:end_time]
      end

      def duration
        minutes = (end_time[0..1].to_i - start_time[0..1].to_i) * 60
        minutes + (end_time[3..4].to_i - start_time[3..4].to_i)
      end
  end

  delegate_all

  def days
    @days ||= DAYS.map { |d| Day.new(name: d, events: events_for(d)) }
  end

  private

    def events_for(day_name)
      event_hashes = object.find_all { |o| o[:day] == day_name }
      event_hashes.map{ |e| Event.new(e) }
    end
end
