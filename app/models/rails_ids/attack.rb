module RailsIds
  ##
  # Attack model in the RailsIds-Gem.
  # Logs all attacks, detected by analyzing events.
  #
  class Attack < ActiveRecord::Base
    RESPONSES = %w(none logout lock_user lock_page).freeze

    # Relations
    has_many :events
  end
end
