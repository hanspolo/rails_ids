require 'test_helper'

module RailsIds
  ##
  #
  #
  class LockPageTest < ActiveSupport::TestCase
    test 'sql injection detected' do
      assert_raises('You are locked out') { RailsIds::Responses::LockPage.run }
    end
  end
end
