require 'spec_helper'

describe CalendarWeekDecorator do
  let(:events)   do
    [
      { name: 'Yoga',       day: 'Sunday',   start_time: '09:00', end_time: '10:00' },
      { name: 'Soccer',     day: 'Saturday', start_time: '14:00', end_time: '15:30' },
      { name: 'Running',    day: 'Saturday', start_time: '11:00', end_time: '12:30' },
      { name: 'Basketball', day: 'Saturday', start_time: '12:00', end_time: '21:30' },
    ]
  end

  let(:decorator) { CalendarWeekDecorator.new(events) }
  let(:days)      { decorator.days }
  let(:saturday)  { days.last}

  describe "#days" do
    it "returns an collection of days" do
      expect(days.collect(&:name)).to eq(["Sunday", "Monday",
                                          "Tuesday", "Wednesday", "Thursday",
                                          "Friday", "Saturday"])
    end

    it "assigns events to the correct day" do
      expect(days.first.events.length).to eq(1)
      expect(days.last.events.length).to eq(3)
    end

    it "gives events a classname corresponding to their time" do
      expect(days.last.events.last.class_name).to match("start-1400 length-90 others-0")
    end

    it "knows how to position events" do
      running = saturday.events.first
      expect(running.name).to eq "Running"

      basketball = saturday.events.second
      expect(basketball.name).to eq "Basketball"

      soccer = saturday.events.last

      expect(running.neighbors).to eq 1
      expect(basketball.neighbors).to eq 2
      expect(soccer.neighbors).to eq 1

      expect(running.column).to eq 0
      expect(basketball.column).to eq 1
      expect(soccer.column).to eq 0
    end
  end

  describe CalendarWeekDecorator::Event do
    let(:klass)     { CalendarWeekDecorator::Event }
    let(:morning)   { klass.new({ start_time: '09:00', end_time: '12:00' }) }
    let(:long_am)   { klass.new({ start_time: '09:00', end_time: '13:00' }) }
    let(:noon)      { klass.new({ start_time: '12:00', end_time: '13:00' }) }
    let(:all_day)   { klass.new({ start_time: '08:00', end_time: '23:00' }) }
    let(:late_pm)   { klass.new({ start_time: '12:30', end_time: '13:00' }) }

    describe "#intersects?" do
      it "true when the other event is encapsulated" do
        expect(all_day.intersects?(morning)).to eq true
      end

      it "true when it encapsulates the other event" do
        expect(morning.intersects?(all_day)).to eq true
      end

      it "true when they're the same time" do
        expect(morning.intersects?(morning)).to eq true
      end

      it "true when the early side overlaps" do
        expect(morning.intersects?(noon)).to eq false
        expect(noon.intersects?(morning)).to eq false

        expect(long_am.intersects?(noon)).to eq true
        expect(noon.intersects?(long_am)).to eq true
      end

      it "true when the late side overlaps" do
        expect(late_pm.intersects?(noon)).to eq true
        expect(noon.intersects?(late_pm)).to eq true
      end
    end
  end
end
