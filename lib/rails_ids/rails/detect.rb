module RailsIds
  ##
  # Monkey patch ActionController::Base and add the methods to
  # detect, analyze and respond to events.
  #
  module Detect
    extend ActiveSupport::Concern

    included do
      ##
      # Gets called inside the scope of the controller.
      # Request, params etc are available.
      #
      # @param :sensors Array, containing all sensors, that will be used
      #
      def ids_detect_callback(sensors:, class_name: nil)
        raise 'sensors needs to be an Array'.freeze unless sensors.is_a?(Array)
        return unless class_name.nil? || class_name == self.class.name
        user = ids_user
        identifier = ids_user_identifier
        sensors.each { |sensor| sensor.run(request, params, user, identifier) }
        ids_analyze(user: user, identifier: identifier)
      end

      ##
      # Set an detection point inside your controller action.
      #
      # Calls ids_detect_callback
      #
      # @param :sensors Array, containing all sensors, that will be used
      #
      def ids_detect(sensors:)
        ids_detect_callback(sensors: sensors)
      end

      ##
      #
      #
      def handle_unverified_request
        RailsIds::Sensors::Sensor.event_detected(
          type: 'CSRF_TOKEN', weight: 'suspicious', sensor: '',
          user: ids_user, identifier: ids_user_identifier
        )
        forgery_protection_strategy.new(self).handle_unverified_request
      end
    end

    #
    module ClassMethods
      ##
      # Add an detection point using the before_action method.
      #
      # Calls ids_detect_callback
      #
      # @param :only Passed to before_action
      # @param :excpet Passed to before_action
      # @param :sensors Array, containing all sensors, that will be used
      #
      def ids_detect(only: nil, except: nil, sensors: [], class_name: nil)
        before_action -> { ids_detect_callback(sensors: sensors, class_name: class_name) },
                      only: only, except: except
      end
    end
  end
end

ActionController::Base.send :include, RailsIds::Detect
