module RailsIds
  module Sensors
    ##
    # Base class for sensors.
    # Sensors are used to detect suspicios events or attacks.
    #
    class Sensor
      ##
      # Default, failing run method.
      # It should be replaced by each implementation of a sensor.
      #
      def self.run
        fail 'Not implemented'
      end

      ##
      # An event was detected and will be written into the database.
      #
      def self.event_detected(type:, weight:, log: nil, sensor:, params: nil, request: nil, user: nil, identifier: nil)
        Event.create! event_type: type,
                      weight: weight,
                      log: log,
                      headers: request.try(:headers),
                      params: params,
                      user_id: user.try(:id),
                      identifier: identifier,
                      controller: params.try(:[], :controller),
                      action: params.try(:[], :action),
                      sensor: sensor
      end
    end
  end
end
