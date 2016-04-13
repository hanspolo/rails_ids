require 'rails_ids/sensors/sensor.rb'

module RailsIds
  module Sensors
    ##
    # A implementation of an input validation sensor that blacklists some input.
    #
    class BlacklistInputValidation < Sensor
      SENSOR = 'BlacklistInputValidation'.freeze
      SQL_INJECTION_REGEX = {
        'suspicious' => [
          %r(';)
        ],
        'attack' => [
          %r([\w\'\s]+[oO][rR]\s+[\w\'\s\=\!]+)
        ]
      }.freeze
      XSS_REGEX = {
        'suspicious' => [
          %r(<.*>(.*</.*>)?)
        ],
        'attack' => [
          %r(<.*script.*src.*=.*["'].+["']/),
          %r(<.*script.*>.*<.*/.*script.*>)
        ]
      }.freeze
      UNPRINTABLE_CHAR_REGEX = {
        'suspicious' => [
          %r(\0)
        ]
      }.freeze
      FILE_ACCESS_REGEX = {
        'suspicious' => [
          %r(../)
        ]
      }.freeze

      def self.run(request, params, user = nil, identifier = nil)
        detect(SQL_INJECTION_REGEX, 'SQL_INJECTION', request, params, user, identifier)
        detect(XSS_REGEX, 'XSS', request, params, user, identifier)
        detect(UNPRINTABLE_CHAR_REGEX, 'UNPRINTABLE_CHAR', request, params, user, identifier)
        detect(FILE_ACCESS_REGEX, 'FILE_ACCESS', request, params, user, identifier)
      end

      def self.detect(checks, type, request, params, user = nil, identifier = nil)
        checks.each do |weight, rs|
          rs.each do |r|
            next if not_matching?(params, r)
            event_detected(type: type, weight: weight, log: "found #{r}",
                           sensor: SENSOR, request: request, params: params,
                           user: user, identifier: identifier)
          end
        end
      end

      def self.not_matching?(params, regex)
        params.flatten.none? { |p| p =~ regex }
      end
    end
  end
end
