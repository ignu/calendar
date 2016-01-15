class CalendarController < ApplicationController
  def index
    @calendar= CalendarWeekDecorator.new(Event.fetch)
  end
end
