# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Bookmark, type: :model do
  before do
    @user = FactoryBot.create(:user)
    @restaurant = FactoryBot.create(:restaurant)
  end

  describe 'ブックマーク機能' do
    context 'ブックマークできる場合' do
      it 'user_idとrestaurant_idがあればブックマークできる' do
        bookmark = FactoryBot.build(:bookmark, user_id: @user.id, restaurant_id: @restaurant.id)
        expect(bookmark).to be_valid
      end

      it 'user_idが同じでも、restaurant_idが異なればbookmarksテーブルに保存できる' do
        another_restaurant = FactoryBot.create(:restaurant)
        bookmark = FactoryBot.create(:bookmark, user_id: @user.id, restaurant_id: @restaurant.id)
        expect(
          FactoryBot.create(:bookmark,
                            user_id: @user.id,
                            restaurant_id: another_restaurant.id)
          ).to be_valid
      end

      it 'restaurant_idが同じでも、user_idが異なればbookmarksテーブルに保存できる' do
        another_user = FactoryBot.create(:user)
        bookmark = FactoryBot.create(:bookmark, user_id: @user.id, restaurant_id: @restaurant.id)
        expect(
          FactoryBot.create(:bookmark,
                            user_id: another_user.id,
                            restaurant_id: @restaurant.id)
        ).to be_valid
      end
    end

    context 'ブックマークできない場合' do
      it 'user_idが空だとブックマークできない' do
        @bookmark = FactoryBot.build(:bookmark, user_id: nil, restaurant_id: @restaurant.id)
        @bookmark.valid?
        expect(@bookmark.errors.full_messages).to include 'ユーザーID が必要です'
      end

      it 'restaurant_idが空だとブックマークできない' do
        @bookmark = FactoryBot.build(:bookmark, user_id: @user.id, restaurant_id: nil)
        @bookmark.valid?
        expect(@bookmark.errors.full_messages).to include 'レストランID が必要です'
      end

      it 'user_idとrestaurant_idの両方が同じデータが既に存在すればブックマークできない' do
        bookmark = FactoryBot.create(:bookmark, user_id: @user.id, restaurant_id: @restaurant.id)
        same_bookmark = FactoryBot.build(:bookmark, user_id: @user.id, restaurant_id: @restaurant.id)
        expect(same_bookmark.valid?).to be false
      end
    end
  end
end
