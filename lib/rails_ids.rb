require 'rails_ids/engine'

#
module RailsIds
  # If you use a model for your users, how is it called?
  mattr_accessor :user_class
  @@user_class = 'User'.freeze

  # How many events of type 'attack' can exist, before responding?
  mattr_accessor :attack_events_threshold
  @@attack_events_threshold = 1

  # How many events of type 'suspicious' can exist, before responding?
  mattr_accessor :suspicious_events_threshold
  @@suspicious_events_threshold = 3

  # How long will suspicious events will counted?
  mattr_accessor :suspicious_timeout
  @@suspicious_timeout = 10.minutes

  # How many events of type 'unsuspicious' can exist, before responding?
  mattr_accessor :unsuspicious_events_threshold
  @@unsuspicious_events_threshold = 10

  # How long will unsuspicious events will counted?
  mattr_accessor :unsuspicious_timeout
  @@unsuspicious_timeout = 5.minutes

  mattr_accessor :response_function
  @@response_function = lambda do |user: nil, attack:|
    if user.present?
      RailsIds::Responses::LockUser.run(user: user)
      RailsIds::Responses::LogoutUser.run(user: user)
    else
      RailsIds::Responses::LockPage.run
    end
    attack
  end

  # Default method to setup RailsIds.
  def self.setup
    yield self
  end
end

##
# Monkey patching
#
require 'rails_ids/rails/detect'
Dir[File.join(File.dirname(__FILE__), 'rails_ids', 'rails', '*.rb')].each do |file|
  require file
end

##
# Responses
#
Dir[File.join(File.dirname(__FILE__), 'rails_ids', 'responses', '*.rb')].each do |file|
  require file
end

##
# Sensors
#
Dir[File.join(File.dirname(__FILE__), 'rails_ids', 'sensors', '*.rb')].each do |file|
  require file
end
