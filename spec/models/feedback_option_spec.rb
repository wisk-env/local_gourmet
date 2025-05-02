# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FeedbackOption, type: :model do
  let(:feedback_option) { build(:feedback_option) }

  context 'feedback_optionsテーブルにデータを保存できる時' do
    it 'option_titleがあれば保存できること' do
      expect(feedback_option).to be_valid
    end
  end

  context 'feedback_optionsテーブルにデータを保存できない時' do
    it 'option_titleが空の場合は保存できないこと' do
      feedback_option.option_title = nil
      feedback_option.valid?
      expect(feedback_option.errors.full_messages).to include '選択肢 を入力してください'
    end
  end

  context 'FeedbackOptionの関連付け' do
    it 'review_feedback_optionsとの関連付けが正しく設定されていること' do
      feedback_option.save
      review_feedback_option = create(:review_feedback_option, feedback_option_id: feedback_option.id)
      expect(feedback_option.review_feedback_options).to include review_feedback_option
    end
  end
end
