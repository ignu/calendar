class Event
  def self.fetch
    [
      { name: 'Yoga', day: 'Sunday', start_time: '9:00', end_time: '10:00' },
      { name: 'Running', day: 'Saturday', start_time: '11:00', end_time: '12:30' },
      { name: 'Running', day: 'Saturday', start_time: '12:00', end_time: '13:30' },
    ]
  end
end
