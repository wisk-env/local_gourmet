class CreateReviewGenres < ActiveRecord::Migration[7.1]
  def change
    create_table :review_genres do |t|
      t.references :review, null: false, foreign_key: true
      t.references :genre, null: false, foreign_key: true

      t.timestamps
    end
  end
end
