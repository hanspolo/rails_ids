require 'rails_ids/sensors/sensor.rb'

module RailsIds
  module Sensors
    ##
    # Implementation of failing login sensors.
    #
    # Multiple failing logins in a short time may be an brute forcing attack.
    #
    class Login < Sensor
      SENSOR = 'Login'.freeze
      TYPE = 'LOGIN'.freeze

      def self.run(_request = nil, _params = nil, _user = nil, identifier)
        event_detected(type: TYPE, weight: 'unsuspicious', sensor: SENSOR, identifier: identifier)
      end
    end
  end
end
