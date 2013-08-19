class CreateSlots < ActiveRecord::Migration
  def change
    create_table :slots do |t|
      t.integer :possible_downloads
      t.string :state
      t.integer :size
      t.string :file
      t.integer :bundle_id

      t.timestamps
    end
    add_index :slots, :bundle_id
  end
end
