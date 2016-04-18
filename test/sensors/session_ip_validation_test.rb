require 'test_helper'

module RailsIds
  #
  class SessionIpValidationTest < ActiveSupport::TestCase
    test 'changing ip in a session detected' do
      request = ActionDispatch::Request.new('REMOTE_ADDR' => '::1')

      RailsIds::Sensors::SessionIpValidation.run(request, {}, nil, 'identifier')
      assert_equal '::1', request.session[:rails_ids_ip_address]
      assert_equal 0, Event.all.count

      request.session[:rails_ids_ip_address] = '42.42.42.42'
      RailsIds::Sensors::SessionIpValidation.run(request, {}, nil, 'identifier')
      assert_equal 1, Event.all.count
    end

    test 'doesn\'t complain when not changing the ip address' do
      request = ActionDispatch::Request.new('REMOTE_ADDR' => '::1')
      10.times do
        RailsIds::Sensors::SessionIpValidation.run(request, {}, nil, 'identifier')
      end
      assert_equal 0, Event.all.count
    end
  end
end
