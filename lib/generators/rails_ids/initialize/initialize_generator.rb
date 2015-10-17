module RailsIds
  module Generators
    ##
    # Defines initialization via rails g rails_ids:initialize
    #
    class InitializeGenerator < Rails::Generators::NamedBase
      source_root File.expand_path('../templates', __FILE__)

      def copy_initializer_file
        copy_file 'rails_ids.rb', "config/initializers/#{file_name}.rb"
      end
    end
  end
end
