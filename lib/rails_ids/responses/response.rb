module RailsIds
  module Responses
    ##
    # Base class of a response.
    #
    # Responses react to an attack and tries to interupt the malicious user.
    #
    class Response
      ##
      # Default, failing run method.
      # It should be replaced by each implementation of a response.
      #
      def self.run(user: nil)
        raise 'Not implemented'
      end
    end
  end
end
