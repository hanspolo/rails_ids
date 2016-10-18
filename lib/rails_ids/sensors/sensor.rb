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
      def self.run(_request, _params, _user, _identifier)
        raise 'Not implemented'
      end

      ##
      # An event was detected and will be written into the database.
      #
      def self.event_detected(type:, weight:, log: nil, params: nil,
                              request: nil, user: nil, identifier: nil, match: nil)
        Event.create! event_type: type,
                      weight: weight,
                      log: log,
                      headers: request.try(:headers),
                      params: params,
                      user_id: user.try(:id),
                      identifier: identifier,
                      controller: params.try(:[], :controller),
                      action: params.try(:[], :action),
                      sensor: name.demodulize.freeze,
                      match: match
      end

      protected

      # params.flatten doesn't work
      # this method will return all values of a hash
      def self.params_values(params)
        values = params.values
        values.each { |v| values.delete_at(values.index(v)) && values << params_values(v) if v.is_a?(Hash) }
        values.flatten
      end
    end
  end
end
