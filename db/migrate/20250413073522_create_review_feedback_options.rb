class CreateReviewFeedbackOptions < ActiveRecord::Migration[7.1]
  def change
    create_table :review_feedback_options do |t|
      t.references :review, null: false, foreign_key: true
      t.references :feedback_option, null: false, foreign_key: true

      t.timestamps
    end
  end
end
