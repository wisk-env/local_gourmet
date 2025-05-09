# frozen_string_literal: true

class CreateReviews < ActiveRecord::Migration[7.1]
  def change
    create_table :reviews do |t|
      t.string :menu, null: false
      t.integer :price, null: false
      t.string :visit_date, null: false
      t.string :visit_time, null: false
      t.integer :number_of_visitors, null: false
      t.text :comment
      t.references :user, null: false, foreign_key: true
      t.references :restaurant, null: false, foreign_key: true

      t.timestamps
    end
  end
end
