##
# Database migration that adds columns to the events table
#
class AddMatchAndVerifiedToRailsIdsEvents < ActiveRecord::Migration
  def change
    change_table :rails_ids_events do |t|
      t.text :match
      t.boolean :verified, default: false
    end
  end
end
