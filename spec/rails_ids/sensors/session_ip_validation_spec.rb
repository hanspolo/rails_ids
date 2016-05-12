require 'rails_helper'

RSpec.describe RailsIds::Sensors::SessionIpValidation do
  it 'detects when an ip changes in a session' do
    request = ActionDispatch::Request.new('REMOTE_ADDR' => '::1')

    RailsIds::Sensors::SessionIpValidation.run(request, {}, nil, 'identifier')
    expect(request.session[:rails_ids_ip_address]).to eq('::1')
    expect(RailsIds::Event.all.count).to eq(0)

    request.session[:rails_ids_ip_address] = '42.42.42.42'
    RailsIds::Sensors::SessionIpValidation.run(request, {}, nil, 'identifier')
    expect(RailsIds::Event.all.count).to eq(1)
  end

  it 'doesn\'t complain when the ip address isn\'nt changing' do
    request = ActionDispatch::Request.new('REMOTE_ADDR' => '::1')
    10.times do
      RailsIds::Sensors::SessionIpValidation.run(request, {}, nil, 'identifier')
    end
    expect(RailsIds::Event.all.count).to eq(0)
  end
end
