feature 'About page' do
  let(:events)   do
    [
      { name: 'Yoga', day: 'Sunday', start_time: '9:00', end_time: '10:00' },
      { name: 'Running', day: 'Saturday', start_time: '11:00', end_time: '12:30' },
      { name: 'Running', day: 'Saturday', start_time: '12:00', end_time: '13:30' },
    ]
  end

  before do
    Event.stub(:fetch) { events }
  end

  scenario 'Visit the calendar' do
    visit '/'
    expect(page).to have_content 'Sunday'

    within ".saturday" do
      expect(page).to have_content 'Running'
      expect(page).to have_css ".start-1100"
    end
  end
end
