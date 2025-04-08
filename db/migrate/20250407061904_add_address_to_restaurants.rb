class AddAddressToRestaurants < ActiveRecord::Migration[7.1]
  def change
    add_column :restaurants, :address, :string, null: false
  end
end
