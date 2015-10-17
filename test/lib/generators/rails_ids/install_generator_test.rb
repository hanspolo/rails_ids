require 'test_helper'
require 'generators/rails_ids/install/install_generator'

module RailsIds
  module Generators
    #
    class InstallGeneratorTest < Rails::Generators::TestCase
      tests InstallGenerator
      destination Rails.root.join('tmp/generators')
      setup :prepare_destination

      test 'generator runs without errors' do
        assert_nothing_raised do
          run_generator
        end
      end
    end
  end
end
