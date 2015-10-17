require 'test_helper'

module RailsIds
  #
  class LoginTest < ActiveSupport::TestCase
    test 'login logged ' do
      RailsIds::Sensors::Login.run(nil, nil, nil, 'identifier')

      assert_equal 1, Event.all.count
    end
  end
end
