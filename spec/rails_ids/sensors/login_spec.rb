require 'rails_helper'

RSpec.describe RailsIds::Sensors::Login do
  it 'logs the login' do
    RailsIds::Sensors::Login.run(nil, nil, nil, 'identifier')

    expect(RailsIds::Event.all.count).to eq(1)
  end
end
