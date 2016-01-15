require 'spec_helper'

describe CalendarWeekDecorator do
  let(:events)    { { }}
  let(:decorator) { CalendarWeekDecorator.new(events) }

  describe "days" do
    it "returns an collection of days" do
      days = decorator.days.collect(&:name)
      expect(days).to eq(["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"])
    end
  end
end
