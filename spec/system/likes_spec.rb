require 'rails_helper'

RSpec.describe "Likes", type: :system do
  before do
    driven_by(:rack_test)
  end

  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let(:restaurant) { create(:restaurant) }
  let(:review) { create(:review, user_id: another_user.id, restaurant_id: restaurant.id) }

  context '投稿された口コミに「いいね」していない場合' do
    it '店舗の詳細画面で他のユーザーの口コミに「いいね」ボタンがあること' do
      sign_in user
      visit restaurant_path(restaurant, review)
      expect(page).to have_selector('.unlike')
    end

    it '店舗の詳細画面で、他のユーザーの口コミの「いいね」ボタンをクリックしたらlikesテーブルのレコードが一つ増えること' do
      sign_in user
      visit restaurant_path(restaurant, review)
      expect{find('.unlike').click}.to change { Like.count }.by(1)
    end

    it '他のユーザーの口コミ詳細画面に遷移したら「いいね」ボタンが表示されること' do
      sign_in user
      visit restaurant_review_path(restaurant_id: restaurant.id, id: review.id)
      expect(page).to have_selector('.unlike')
    end

    it '他のユーザーの口コミ詳細画面で「いいね」ボタンをクリックしたらlikesテーブルのレコードが一つ増えること' do
      sign_in user
      visit restaurant_review_path(restaurant_id: restaurant.id, id: review.id)
      expect{find('.unlike').click}.to change { Like.count }.by(1)
    end
  end
end
