class CreateWeathers < ActiveRecord::Migration
  def change
    create_table :weathers do |t|
      t.integer :weather_id, unique: true
      t.date    :date
      t.string  :temperature
    end

    add_index :weathers, :weather_id
  end
end
