class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.float   :latitude
      t.float   :longitude
      t.string  :city
      t.string  :state
      t.integer :weather_id
    end
    add_index :locations, :weather_id
  end
end
