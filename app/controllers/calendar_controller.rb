class CalendarController < ApplicationController
  def index
    events = Hash.new
    @calendar= CalendarWeekDecorator.new(events)
  end
end
