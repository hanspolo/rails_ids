##
# Database migration that creates the attacks table
#
class CreateRailsIdsAttacks < ActiveRecord::Migration
  def change
    create_table :rails_ids_attacks do |t|
      t.string :response
      t.timestamps null: false
    end
  end
end
