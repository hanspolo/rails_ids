module RailsIds
  ##
  # Event model in the RailsIds-Gem.
  # Logs all events that where relevant for detecting an attack.
  #
  # An event is of a type, that describes what an user was doing,
  # and a weight, to be used by the response module, to know how to react.
  #
  class Event < ActiveRecord::Base
    TYPES = %w(INSUFFICIANT_AUTHORIZATION LOGIN SQL_INJECTION XSS
               UNPRINTABLE_CHAR CSRF_TOKEN FILE_ACCESS SESSION
               AUTOMATICALLY_RECOGNIZED).freeze
    WEIGHT = %w(unsuspicious suspicious attack).freeze

    # Relations
    belongs_to :user, class_name: RailsIds.user_class
    belongs_to :attack

    # Validations
    validates :event_type, presence: true, inclusion: { in: TYPES, message: '%{value} is not a valid type' }
    validates :weight, presence: true, inclusion: { in: WEIGHT, message: '%{value} is not a valid weight' }

    # Scopes
    scope :in_time, -> (timeout) { where('created_at > ?', Time.zone.now - timeout) }
  end
end
