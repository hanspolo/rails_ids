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
        if @prev_migration_nr
          @prev_migration_nr += 1
        else
          @prev_migration_nr = Time.now.utc.strftime('%Y%m%d%H%M%S').to_i
        end
        @prev_migration_nr.to_s
      end

      def copy_migrations
        migration_template 'create_rails_ids_attacks.rb', 'db/migrate/create_rails_ids_attacks.rb'
        migration_template 'create_rails_ids_events.rb', 'db/migrate/create_rails_ids_events.rb'
      end
    end
  end
end
