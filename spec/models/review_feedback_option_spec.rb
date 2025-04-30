require 'rails_helper'

RSpec.describe ReviewFeedbackOption, type: :model do
  let(:review) { create(:review) }
  let(:feedback_option) { create(:feedback_option) }

  describe 'ReviewとFeedbackOptionの中間テーブル' do
    context 'review_feedback_optionsテーブルにデータを保存できる時' do
      it 'review_idとfeedback_option_idがあれば保存できること' do
        review_feedback_option = build(:review_feedback_option, review_id: review.id, feedback_option_id: feedback_option.id)
        expect(review_feedback_option).to be_valid
      end

      it 'review_idが同じでも、feedback_option_idが異なれば保存できること' do
        review_feedback_option = create(:review_feedback_option, review_id: review.id, feedback_option_id: feedback_option.id)
        another_feedback_option = create(:feedback_option)
        another_review_feedback_option = build(:review_feedback_option,
                                          review_id: review.id, feedback_option_id: another_feedback_option.id)
        expect(another_review_feedback_option).to be_valid
      end

      it 'feedback_option_idが同じでも、review_idが異なれば保存できること' do
        review_feedback_option = create(:review_feedback_option, review_id: review.id, feedback_option_id: feedback_option.id)
        another_review = create(:review)
        another_review_feedback_option = build(:review_feedback_option,
                                          review_id: another_review.id, feedback_option_id: feedback_option.id)
        expect(another_review_feedback_option).to be_valid
      end
    end

    context 'review_feedback_optionsテーブルにデータを保存できない時' do
      it 'review_idが空だと保存できないこと' do
        review_feedback_option = build(:review_feedback_option, review_id: nil, feedback_option_id: feedback_option.id)
        review_feedback_option.valid?
        expect(review_feedback_option.errors.full_messages).to include "レビューID が必要です"
      end

      it 'feedback_option_idが空だと保存できないこと' do
        review_feedback_option = build(:review_feedback_option, review_id: review.id, feedback_option_id: nil)
        review_feedback_option.valid?
        expect(review_feedback_option.errors.full_messages).to include "フィードバックオプションID が必要です"
      end

      it 'review_idとfeedback_option_idの両方が同じデータが既に存在すれば保存できないこと' do
        review_feedback_option = create(:review_feedback_option, review_id: review.id, feedback_option_id: feedback_option.id)
        same_data = build(:review_feedback_option, review_id: review.id, feedback_option_id: feedback_option.id)
        expect(same_data.valid?).to be false
      end
    end
  end
end
