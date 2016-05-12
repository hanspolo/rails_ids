require 'rails_ids/responses/response.rb'

module RailsIds
  module Responses
    ##
    # Implementation of a response, that locks the requested page
    #
    class Debug < Response
      def self.run(user: nil, attack:)
        return if Rails.env == 'production'
        @ids_debug = "<p>User #{user.inspect} was detected.</p>"
        attack.events.each do |event|
          @ids_debug += "<p>An event was logged: #{event.inspect}</p>"
        end
      end
    end
  end
end
