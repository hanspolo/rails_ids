##
# Database migration that adds the events table
#
class CreateRailsIdsMachineLearningTokens < ActiveRecord::Migration
  def change
    create_table :rails_ids_machine_learning_tokens do |t|
      t.string :token

      t.timestamps null: false
    end
  end
end
