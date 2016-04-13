require 'spec_helper'
require 'rails_ids/sensors/login'

RSpec.describe RailsIds::Sensors::Login do
  it 'login logged' do
    RailsIds::Sensors::Login.run(nil, nil, nil, 'identifier')
    expect(Event.all.count).to eq(1)
  end
end
