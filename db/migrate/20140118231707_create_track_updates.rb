class CreateTrackUpdates < ActiveRecord::Migration
  def change
    create_table :track_updates do |t|
      t.references :user, index: true
      t.string :device_id
      t.string :title
      t.string :artist
      t.integer :position

      t.timestamps
    end
  end
end
