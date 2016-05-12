require 'rails_helper'

RSpec.describe RailsIds::Event, type: :model do
  it 'orders by last name' do
    RailsIds::Event.create!(event_type: 'SESSION', weight: 'suspicious')
    RailsIds::Event.create!(event_type: 'LOGIN', weight: 'unsuspicious')

    expect(RailsIds::Event.all.count).to eq(2)
  end
end
