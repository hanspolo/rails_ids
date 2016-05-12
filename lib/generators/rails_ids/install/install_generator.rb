require 'rails/generators/migration'

module RailsIds
  module Generators
    ##
    # Defines installation via rails g rails_ids:install
    #
    class InstallGenerator < ::Rails::Generators::Base
      include Rails::Generators::Migration
      source_root File.expand_path('../templates', __FILE__)
      desc 'add the migrations'

      def self.next_migration_number(_path)
        @prev_migration_nr ||= nil
        if @prev_migration_nr
          @prev_migration_nr += 1
        else
          @prev_migration_nr = Time.now.utc.strftime('%Y%m%d%H%M%S').to_i
        end
        @prev_migration_nr.to_s
      end

      def copy_migrations
        migration_template 'create_rails_ids_attacks.rb',
                           'db/migrate/create_rails_ids_attacks.rb'
        migration_template 'create_rails_ids_events.rb',
                           'db/migrate/create_rails_ids_events.rb'
        migration_template 'create_rails_ids_machine_learning_examples.rb',
                           'db/migrate/create_rails_ids_machine_learning_examples.rb'
        migration_template 'create_rails_ids_machine_learning_results.rb',
                           'db/migrate/create_rails_ids_machine_learning_results.rb'
        migration_template 'create_rails_ids_machine_learning_tokens.rb',
                           'db/migrate/create_rails_ids_machine_learning_tokens.rb'
        migration_template 'add_match_and_verified_to_rails_ids_events.rb',
                           'db/migrate/add_match_and_verified_to_rails_ids_events.rb'
      end
    end
  end
end
