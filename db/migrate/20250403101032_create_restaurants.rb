class CreateRestaurants < ActiveRecord::Migration[7.1]
  def change
    create_table :restaurants do |t|
      t.string :name, null: false
      t.float :lat, null: false
      t.float :lng, null: false

      t.timestamps
      t.index [:lat, :lng], unique: true
    end
  end
end
