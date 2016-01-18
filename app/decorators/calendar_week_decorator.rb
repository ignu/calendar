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

      order_events
      set_neighbors_and_columns
    end

    private

      def order_events
        self.events.sort! { |e1, e2| e1.start_time <=> e2.start_time }
      end

      def set_neighbors_and_columns
        self.events.each do |event|
          neighbors = self.events.find_all do |other|
            other != event && event.intersects?(other)
          end
          event.neighbors = neighbors.count
          allocate_first_available_column(event, neighbors)
        end
      end

      def allocate_first_available_column(event, neighbors)
        taken_columns = neighbors.map(&:column).flatten

        event.column = ((0..10).to_a - taken_columns).first
      end
  end

  class Event
    attr_accessor :class_name, :name, :options

    # how many other events are there at this time?
    attr_accessor :neighbors

    # which column does this go in
    attr_accessor :column

    def initialize(options)
      self.name = options[:name]
      self.options = options
    end

    def class_name
      "start-#{start_time} length-#{duration} neighbors-#{neighbors} col-#{column}".gsub(/:/, "")
    end

    def start_time
      options[:start_time]
    end

    def end_time
      options[:end_time]
    end

    def ==(other)
      other.name == name && other.start_time == start_time && other.end_time && end_time
    end

    def intersects?(other)
      other.encompasses?(self) || encompasses?(other) || overlaps?(other)
    end

    def encompasses?(other)
      start_time <= other.start_time && end_time >= other.end_time
    end

    def overlaps?(other)
      overlaps_left_side(other) || overlaps_right_side(other)
    end

    def overlaps_right_side(other)
      other.start_time <= start_time && other.end_time > start_time
    end

    def overlaps_left_side(other)
      other.start_time < end_time && other.end_time >= end_time
    end

    def duration
      minutes = (end_time[0..1].to_i - start_time[0..1].to_i) * 60
      minutes + (end_time[3..4].to_i - start_time[3..4].to_i)
    end

    def to_s
      name
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
