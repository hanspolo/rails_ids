require 'test_helper'

module RailsIds
  ##
  # Check that the regex find blacklisted input.
  #
  class BlacklistInputValidationTest < ActiveSupport::TestCase
    test 'sql injection detected' do
      request = ActionDispatch::Request.new(nil)
      RailsIds::Sensors::BlacklistInputValidation.run(
        request, { clean: 'Hello World!' }, nil, 'identifier'
      )
      assert_equal 0, Event.all.count

      RailsIds::Sensors::BlacklistInputValidation.run(
        request, { suspicious: '\';--' }, nil, 'identifier'
      )
      assert_equal 1, Event.all.count
      assert_equal 0, Event.where(weight: 'attack').count

      RailsIds::Sensors::BlacklistInputValidation.run(
        request, { attack: 'foo\' OR 1!=2;--' }, nil, 'identifier'
      )
      assert_equal 1, Event.where(weight: 'attack').count
    end

    test 'xss detected' do
      request = ActionDispatch::Request.new(nil)

      RailsIds::Sensors::BlacklistInputValidation.run(
        request, { clean: 'Hello World!' }, nil, 'identifier'
      )
      assert_equal 0, Event.all.count

      RailsIds::Sensors::BlacklistInputValidation.run(
        request, { suspicious: 'Love < All > Live' }, nil, 'identifier'
      )
      assert_equal 1, Event.all.count
      assert_equal 0, Event.where(weight: 'attack').count

      RailsIds::Sensors::BlacklistInputValidation.run(
        request, { attack: '<script>alert(\'Attackable\')</script>' }, nil, 'identifier'
      )
      assert_equal 1, Event.where(weight: 'attack').count
    end

    test 'unprintable char detected' do
    end

    test 'file access detected' do
      request = ActionDispatch::Request.new(nil)

      RailsIds::Sensors::BlacklistInputValidation.run(
        request, { clean: 'Read more ...' }, nil, 'identifier'
      )
      assert_equal 0, Event.all.count

      RailsIds::Sensors::BlacklistInputValidation.run(
        request, { suspicious: '../private.log' }, nil, 'identifier'
      )
      assert_equal 1, Event.all.count
      assert_equal 0, Event.where(weight: 'attack').count
    end
  end
end
