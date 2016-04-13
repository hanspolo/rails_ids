module RailsIds
  ##
  # Monkey patch ActionController::Base and add some user-helpers.
  #
  module User
    extend ActiveSupport::Concern

    included do
      ##
      # If a current_user is given, return it.
      #
      # @return Object
      #
      def ids_user
        user = try(:current_user)
        user
      end

      ##
      # Builds the identifier.
      # It is based on sessionId.
      #
      # Even if a sessionId is present, it does not mean that it identifies the user.
      # The sessionId is changing, if the user deletes the cookies.
      #
      # @return String
      #
      def ids_user_identifier
        identifier = (session[:rails_ids_id] ||= SecureRandom.hex(16))
        logger.debug "User identifier #{identifier}"
        identifier
      end
    end
  end

  ##
  # Monkey patch ActionController::Base and add some attack-helpers.
  #
  module Analyzer
    extend ActiveSupport::Concern

    USER_OR_TOKEN_QUERY = 'rails_ids_events.user_id = :user_id OR
                           rails_ids_events.identifier = :identifier'.freeze

    included do
      ##
      #
      #
      def ids_analyze(user: nil, identifier: nil)
        attack = ids_find_attack(user: user, identifier: identifier)
        ids_respond(user: user, attack: attack) if attack.present?
      end

      ##
      #
      #
      def ids_respond(user: nil, attack:)
        RailsIds.response_function.call(user: user, attack: attack)
      end

      ##
      # Checks if an attack is given for the user or identifier.
      # If non is found, it checks if the events are dangerous.
      #
      # @return Attack
      #
      def ids_find_attack(user: nil, identifier: nil)
        raise 'User or identifier required' if user.nil? && identifier.nil?
        attack = Attack.joins(:events).where(USER_OR_TOKEN_QUERY, user_id: user.try(:id), identifier: identifier).last
        unless attack
          events = ids_find_events(user: user, identifier: identifier)
          if ids_events_dangerous?(*events)
            attack = Attack.create!(events: events.flatten, response: 'none')
          end
        end
        attack
      end

      ##
      # Loads all events for the user or identifier from database.
      #
      # @return Array[attacking_events, suspicious_events, unsuspicious_events]
      #
      def ids_find_events(user: nil, identifier: nil)
        events = Event.where(attack: nil).where(USER_OR_TOKEN_QUERY, user_id: user.try(:id), identifier: identifier)
        [events.where(weight: 'attack'),
         events.in_time(RailsIds.suspicious_timeout).where(weight: 'suspicious'),
         events.in_time(RailsIds.unsuspicious_timeout).where(weight: 'unsuspicious')]
      end

      ##
      # Compares the found events with the thresholds and check if they
      # overcome the settings.
      #
      # @return Boolean
      #
      def ids_events_dangerous?(attacks, suspicious, unsuspicious)
        attacks.count >= RailsIds.attack_events_threshold ||
          suspicious.count >= RailsIds.suspicious_events_threshold ||
          unsuspicious.count >= RailsIds.unsuspicious_events_threshold
      end
    end
  end
end

ActionController::Base.send :include, RailsIds::User
ActionController::Base.send :include, RailsIds::Analyzer
