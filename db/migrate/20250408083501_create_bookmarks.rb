# frozen_string_literal: true

class CreateBookmarks < ActiveRecord::Migration[7.1]
  def change
    create_table :bookmarks do |t|
      t.references :user, null: false, foreign_key: true
      t.references :restaurant, null: false, foreign_key: true

      t.timestamps
      t.index %i[user_id restaurant_id], unique: true
    end
  end
end
