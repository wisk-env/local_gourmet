require 'rails_helper'

RSpec.describe Restaurant, type: :model do
  describe '店舗登録' do
    let(:restaurant) { build(:restaurant) }

    context '店舗登録ができる時' do
      it 'name, address, lat, lng があれば登録できること' do
        expect(restaurant).to be_valid
      end
    end

    context '店舗登録ができない時' do
      it 'nameが空だと登録できないこと' do
        restaurant.name = nil
        restaurant.valid?
        expect(restaurant.errors.full_messages).to include "店舗名 を入力してください"
      end

      it 'addressが空だと登録できないこと' do
        restaurant.address = nil
        restaurant.valid?
        expect(restaurant.errors.full_messages).to include "住所 を入力してください"
      end

      it 'latが空だと登録できないこと' do
        restaurant.lat = nil
        restaurant.valid?
        expect(restaurant.errors.full_messages).to include "緯度 を入力してください"
      end

      it 'lngが空だと登録できないこと' do
        restaurant.lng = nil
        restaurant.valid?
        expect(restaurant.errors.full_messages).to include "経度 を入力してください"
      end

      it 'latとlngの両方のデータが既に存在するデータは登録できないこと' do
        restaurant.save
        same_restaurant = build(:restaurant, lat: restaurant.lat, lng: restaurant.lng)
        expect(same_restaurant.valid?).to be false
      end
    end
  end

  describe 'Restaurantの関連付け' do
    let!(:restaurant) { create(:restaurant) }

    it 'reviewsとの関連付けが正しく設定されていること' do
      review = create(:review, restaurant: restaurant)
      expect(restaurant.reviews).to include review
    end

    it 'bookmarksとの関連付けが正しく設定されていること' do
      bookmark = create(:bookmark, restaurant: restaurant)
      expect(restaurant.bookmarks).to include bookmark
    end
  end
end
