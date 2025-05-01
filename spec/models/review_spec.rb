require 'rails_helper'

RSpec.describe Review, type: :model do
  describe '口コミ投稿' do
    let(:review) { build(:review) }

    context '口コミ投稿ができる時' do
      it 'menu, price, visit_date, visit_time, number_of_visitors, user_id, restaurant_idがあれば投稿できる' do
        expect(review).to be_valid
      end
    end

    context '口コミ投稿ができない時' do
      it 'menuが空の場合は投稿できないこと' do
        review.menu = nil
        review.valid?
        expect(review.errors.full_messages).to include("注文したメニュー を入力してください")
      end

      it 'priceが空の場合は投稿できないこと' do
        review.price = nil
        review.valid?
        expect(review.errors.full_messages).to include("料金 を入力してください")
      end

      it 'visit_dateが空の場合は投稿できないこと' do
        review.visit_date = nil
        review.valid?
        expect(review.errors.full_messages).to include("ご利用日 を入力してください")
      end

      it 'visit_timeが空の場合は投稿できないこと' do
        review.visit_time = nil
        review.valid?
        expect(review.errors.full_messages).to include("ご利用時間帯 を入力してください")
      end

      it 'number_of_visitorsが空の場合は投稿できないこと' do
        review.number_of_visitors = nil
        review.valid?
        expect(review.errors.full_messages).to include("ご利用人数 を入力してください")
      end
    end
  end

  describe 'Reviewの関連付け' do
    let(:review) { create(:review) }

    it 'review_feedback_optionsとの関連付けが正しく設定されていること' do
      review_feedback_option = create(:review_feedback_option, review_id: review.id)
      expect(review.review_feedback_options).to include review_feedback_option
    end

    it 'review_genresとの関連付けが正しく設定されていること' do
      review_genre = create(:review_genre, review_id: review.id)
      expect(review.review_genres).to include review_genre
    end

    it 'likesとの関連付けが正しく設定されていること' do
      like = create(:like, review_id: review.id)
      expect(review.likes).to include like
    end
  end

  describe 'ユーザーが口コミに「いいね」したか判定するメソッドのテスト' do
    let(:user) { create(:user) }
    let(:review) { create(:review) }

    it 'ユーザーが口コミに「いいね」した場合はtrueを返すこと' do
      like = create(:like, user_id: user.id, review_id: review.id)
      expect(review.liked_by?(user)).to eq(true)
    end

    it 'ユーザーが口コミに「いいね」していない場合はfalseを返すこと' do
      expect(review.liked_by?(user)).to eq(false)
    end
  end
end
