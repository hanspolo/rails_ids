require 'rails_ids/responses/response.rb'

module RailsIds
  module Responses
    ##
    # Implementation of a response, that locks the requested page
    #
    class LockPage < Response
      def self.run(*)
        fail 'You are locked out'
      end
    end
  end
end
