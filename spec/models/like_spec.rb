# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Like, type: :model do
  let(:user) { create(:user) }
  let(:review) { create(:review) }

  describe 'いいね機能' do
    context 'いいねできる場合' do
      it 'user_idとreview_idがあれば「いいね」できる' do
        like = build(:like, user_id: user.id, review_id: review.id)
        expect(like).to be_valid
      end

      it 'user_idが同じでも、review_idが異なればlikesテーブルに保存できる' do
        like = create(:like, user_id: user.id, review_id: review.id)
        another_review = create(:review)
        another_like = build(:like, user_id: user.id, review_id: another_review.id)
        expect(another_like).to be_valid
      end

      it 'review_idが同じでも、user_idが異なればlikesテーブルに保存できる' do
        like = create(:like, user_id: user.id, review_id: review.id)
        another_user = create(:user)
        another_like = build(:like, user_id: another_user.id, review_id: review.id)
        expect(another_like).to be_valid
      end
    end

    context 'いいねできない場合' do
      it 'user_idが空だと「いいね」できない' do
        like = build(:like, user_id: nil, review_id: review.id)
        like.valid?
        expect(like.errors.full_messages).to include 'ユーザーID が必要です'
      end

      it 'review_idが空だと「いいね」できない' do
        like = build(:like, user_id: user.id, review_id: nil)
        like.valid?
        expect(like.errors.full_messages).to include 'レビューID が必要です'
      end

      it 'user_idとreview_idの両方が同じデータが既に存在すれば「いいね」できない' do
        like = create(:like, user_id: user.id, review_id: review.id)
        same_like = build(:like, user_id: user.id, review_id: review.id)
        expect(same_like.valid?).to be false
      end
    end
  end
end
