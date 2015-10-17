##
# Database migration that adds the events table
#
class CreateRailsIdsEvents < ActiveRecord::Migration
  def change
    create_table :rails_ids_events do |t|
      t.string :event_type, null: false
      t.string :weight, null: false
      t.text :log
      t.text :headers
      t.text :params

      t.integer :user_id
      t.string :identifier

      t.string :controller
      t.string :action
      t.string :sensor

      t.references :attack

      t.timestamps null: false
    end
  end
end
