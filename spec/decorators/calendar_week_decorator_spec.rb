require 'spec_helper'

describe CalendarWeekDecorator do
  let(:events)   do
    [
      { name: 'Yoga', day: 'Sunday', start_time: '9:00', end_time: '10:00' },
      { name: 'Running', day: 'Saturday', start_time: '11:00', end_time: '12:30' },
      { name: 'Running', day: 'Saturday', start_time: '12:00', end_time: '13:30' },
    ]
  end

  let(:decorator) { CalendarWeekDecorator.new(events) }
  let(:days)      { decorator.days }

  describe "days" do
    it "returns an collection of days" do
      expect(days.collect(&:name)).to eq(["Sunday", "Monday",
                                          "Tuesday", "Wednesday", "Thursday",
                                          "Friday", "Saturday"])
    end

    it "assigns events to the correct day" do
      expect(days.first.events.length).to eq(1)
      expect(days.last.events.length).to eq(2)
    end
  end
end
