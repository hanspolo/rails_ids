require 'spec_helper'
require 'rails_ids/sensors/session_ip_validation'

RSpec.describe RailsIds::Sensors::SessionIpValidation do
  it 'changing ip in a session detected ' do
    request = ActionDispatch::Request.new('REMOTE_ADDR' => '::1')

    RailsIds::Sensors::SessionIpValidation.run(request, {}, nil, 'identifier')
    expect(request.session[:rails_ids_ip_address]).to eq('::1')
    expect(Event.all.count).to eq(0)

    request.session[:rails_ids_ip_address] = '42.42.42.42'
    RailsIds::Sensors::SessionIpValidation.run(request, {}, nil, 'identifier')
    expect(Event.all.count).to eq(1)
  end

  it 'doesn\'t complain when not changing the ip address' do
    request = ActionDispatch::Request.new('REMOTE_ADDR' => '::1')

    time = Benchmark.ms do
      100_000.times do
        RailsIds::Sensors::SessionIpValidation.run(request, {}, nil, 'identifier')
      end
    end
    expect(Event.all.count).to eq(0)
    expect(time).to be > 100
  end
end
