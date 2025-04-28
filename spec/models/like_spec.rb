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
  end
end
