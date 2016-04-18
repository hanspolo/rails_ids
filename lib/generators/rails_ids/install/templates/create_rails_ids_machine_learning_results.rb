##
# Database migration that adds the events table
#
class CreateRailsIdsMachineLearningResults < ActiveRecord::Migration
  def change
    create_table :rails_ids_machine_learning_results do |t|
      t.integer :a
      t.decimal :w
      t.string :status

      t.timestamps null: false
    end
  end
end
