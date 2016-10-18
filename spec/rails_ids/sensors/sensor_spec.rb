require 'rails_helper'

RSpec.describe RailsIds::Sensors::Sensor do
  #################
  # params_values #
  #################
  it 'returns all values of a onedimensional hash' do
    hash = { 'key1' => 'value1', key2: 'value2' }

    values = RailsIds::Sensors::Sensor.params_values(hash)

    expect(values).to contain_exactly('value1', 'value2')
  end

  it 'returns all values of a nested hash' do
    hash = { 'key1' => 'value1', key2: 'value2', key3: { key3_1: 'value3.1', key3_2: { key3_2_1: 'value3.2.1' } } }

    values = RailsIds::Sensors::Sensor.params_values(hash)

    expect(values).to contain_exactly('value1', 'value2', 'value3.1', 'value3.2.1')
  end
end
