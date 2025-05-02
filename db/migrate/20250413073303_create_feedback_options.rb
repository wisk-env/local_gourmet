# frozen_string_literal: true

class CreateFeedbackOptions < ActiveRecord::Migration[7.1]
  def change
    create_table :feedback_options do |t|
      t.string :option_title, null: false

      t.timestamps
    end
  end
end
