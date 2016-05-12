require 'rails_ids/sensors/sensor.rb'

module RailsIds
  module Sensors
    ##
    # Implementation of failing login sensors.
    #
    # Multiple failing logins in a short time may be an brute forcing attack.
    #
    class Login < Sensor
      TYPE = 'LOGIN'.freeze

      ##
      # Executes the classification on all parameters and
      # create event if any is suspicious
      #
      # @param _request Unused rails request object
      # @param _params Unused params from the controller
      # @param _user Unused user object
      # @param identifier An identifier to recognize users without an id
      #
      def self.run(_request, _params, _user, identifier)
        event_detected(type: TYPE, weight: 'unsuspicious', identifier: identifier)
      end
    end
  end
end
