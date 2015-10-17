require 'rails_ids/responses/response.rb'

module RailsIds
  module Responses
    ##
    # Implementation of a response, that locks the user
    #
    class LockUser < Response
      def self.run(user:)
      end
    end
  end
end
