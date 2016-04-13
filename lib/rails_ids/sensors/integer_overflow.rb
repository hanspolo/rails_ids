require 'rails_ids/sensors/sensor.rb'

module RailsIds
  module Sensors
    ##
    #
    #
    class IntegerOverflow < Sensor
      SENSOR = 'Integer Overflow'.freeze
      TYPE = 'OVERFLOW'.freeze

      def self.run(_request = nil, _params = nil, _user = nil, identifier)
        event_detected(type: TYPE, weight: 'unsuspicious', sensor: SENSOR, identifier: identifier)
      end
    end
  end
end