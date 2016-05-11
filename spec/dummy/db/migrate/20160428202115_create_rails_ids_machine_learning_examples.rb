##
# Database migration that adds the events table
#
class CreateRailsIdsMachineLearningExamples < ActiveRecord::Migration
  def change
    create_table :rails_ids_machine_learning_examples do |t|
      t.text :text
      t.integer :classifier
      t.string :status

      t.timestamps null: false
    end
  end
end
