require 'rails_ids/sensors/sensor.rb'

module RailsIds
  module Sensors
    ##
    # Default implementation of an input validation sensor
    #
    class DefaultInputValidation < Sensor
      def self.run(_request, _params, _user, _identifier)
      end
    end
  end
end
