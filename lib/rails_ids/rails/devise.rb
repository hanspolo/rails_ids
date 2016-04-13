require 'rails_ids/sensors/login.rb'

module RailsIds
  ##
  # Monkey patch Devise::SessionsController and add the methods to
  # detect, analyze and respond to events.
  #
  module Devise
    extend ActiveSupport::Concern

    included do
      ids_detect only: [:create],
                 sensors: [RailsIds::Sensors::Login],
                 class_name: 'Devise::SessionsController'.freeze
    end
  end
end

ActionController::Base.send :include, RailsIds::Devise

# Warden::Manager.after_set_user except: :fetch do |record, warden, options|
#   if record.respond_to?(:faled_attempts) && warden.authenticated?(options[:scope])
#     Event.create! event_type: 'LOGIN',
#                   weight: 'unsuspicious',
#                   identifier: ids_user_identifier,
#                   controller: 'Devise::SessionsController',
#                   action: 'create',
#                   sensor: 'Login'
#   end
# end
