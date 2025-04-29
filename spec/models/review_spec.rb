require 'rails_helper'

RSpec.describe Review, type: :model do
  describe '口コミ投稿' do
    before do
      @review = build(:review)
    end

    context '口コミ投稿ができる時' do
      it 'menu, price, visit_date, visit_time, number_of_visitors, user_id, restaurant_idがあれば投稿できる' do
        expect(@review).to be_valid
      end
    end

    context '口コミ投稿ができない時' do
      it 'menuが空の場合は投稿できないこと' do
        @review.menu = nil
        @review.valid?
        expect(@review.errors.full_messages).to include("注文したメニュー を入力してください")
      end

      it 'priceが空の場合は投稿できないこと' do
        @review.price = nil
        @review.valid?
        expect(@review.errors.full_messages).to include("料金 を入力してください")
      end

      it 'visit_dateが空の場合は投稿できないこと' do
        @review.visit_date = nil
        @review.valid?
        expect(@review.errors.full_messages).to include("ご利用日 を入力してください")
      end

      it 'visit_timeが空の場合は投稿できないこと' do
        @review.visit_time = nil
        @review.valid?
        expect(@review.errors.full_messages).to include("ご利用時間帯 を入力してください")
      end

      it 'number_of_visitorsが空の場合は投稿できないこと' do
        @review.number_of_visitors = nil
        @review.valid?
        expect(@review.errors.full_messages).to include("ご利用人数 を入力してください")
      end
    end
  end
end
