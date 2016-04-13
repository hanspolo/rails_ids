require 'rails_ids/sensors/sensor.rb'

module RailsIds
  module Sensors
    ##
    # A implementation of an input validation sensor that blacklists some input.
    #
    class SessionIpValidation < Sensor
      SENSOR = 'SessionIpValidation'.freeze
      TYPE = 'SESSION'.freeze

      def self.run(request, _params, user = nil, identifier = nil)
        remote_ip = request.remote_ip.freeze
        request.session[:rails_ids_ip_address] ||= remote_ip
        ip = request.session[:rails_ids_ip_address].freeze
        if ip != remote_ip
          event_detected(type: TYPE, weight: 'suspicious'.freeze,
                         log: "ip address changed from #{ip} #{remote_ip}",
                         sensor: SENSOR, request: nil, params: nil,
                         user: user, identifier: identifier)
        end
      end
    end
  end
end
