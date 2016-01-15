feature 'About page' do
  scenario 'Visit the calendar' do
    visit '/'
    expect(page).to have_content 'Sunday'
  end
end
