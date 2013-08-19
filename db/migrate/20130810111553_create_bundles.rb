class CreateBundles < ActiveRecord::Migration
  def change
    create_table :bundles do |t|
      t.string :state
      t.integer :possible_downloads
      t.string :destroy_code
      t.string :zip_archive
      t.binary :text
      t.string :url_id
      t.timestamps
    end
    add_index :bundles, :url_id
    add_index :bundles, :destroy_code
  end
end
