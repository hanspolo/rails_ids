require 'rails_ids/sensors/sensor.rb'

module RailsIds
  module Sensors
    ##
    #
    #
    class IntegerOverflow < Sensor
      TYPE = 'OVERFLOW'.freeze

      def self.run(_request, _params, _user, identifier)
        event_detected(type: TYPE, weight: 'unsuspicious', identifier: identifier)
      end
    end
  end
end
