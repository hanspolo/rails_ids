require 'test_helper'
require 'generators/rails_ids/initialize/initialize_generator'

module RailsIds
  module Generators
    #
    class InitializeGeneratorTest < Rails::Generators::TestCase
      tests InitializeGenerator
      destination Rails.root.join('tmp/generators')
      setup :prepare_destination

      test 'generator runs without errors' do
        assert_nothing_raised do
          run_generator ['rails_ids']
        end
      end
    end
  end
end
