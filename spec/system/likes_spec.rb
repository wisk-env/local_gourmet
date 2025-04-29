require 'rails_helper'

RSpec.describe "Likes", type: :system do
  before do
    driven_by(:rack_test)
  end

  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let(:restaurant) { create(:restaurant) }
  let(:another_restaurant) { create(:restaurant) }
  let(:my_review) { create(:review, user_id: user.id, restaurant_id: another_restaurant.id) }
  let(:review) { create(:review, user_id: another_user.id, restaurant_id: restaurant.id) }

  context '投稿された口コミに「いいね」していない場合' do
    before do
      sign_in user
    end

    it '店舗の詳細画面で他のユーザーの口コミに「いいね」ボタンがあること' do
      visit restaurant_path(restaurant, review)
      expect(page).to have_selector('.unliked')
      expect(page).to have_selector '.review-likes-count', text: '0'
    end

    it '店舗の詳細画面で、他のユーザーの口コミの「いいね」ボタンをクリックしたらlikesテーブルのレコードが一つ増えること' do
      visit restaurant_path(restaurant, review)
      expect{find('.unliked').click}.to change { Like.count }.by(1)
    end

    it '他のユーザーの口コミ詳細画面に遷移したら「いいね」ボタンが表示されること' do
      visit restaurant_review_path(restaurant_id: restaurant.id, id: review.id)
      expect(page).to have_selector('.unliked')
      expect(page).to have_selector '.review-likes-count', text: '0'
    end

    it '他のユーザーの口コミ詳細画面で「いいね」ボタンをクリックしたらlikesテーブルのレコードが一つ増えること' do
      visit restaurant_review_path(restaurant_id: restaurant.id, id: review.id)
      expect{find('.unliked').click}.to change { Like.count }.by(1)
    end
  end

  context '投稿された口コミに既に「いいね」している場合' do
    before do
      like = create(:like, user_id: user.id, review_id: review.id)
      sign_in user
      visit restaurant_path(restaurant, review)
    end

    it '既に「いいね」している場合は、「いいね」を解除するボタンが表示されること' do
      expect(page).to have_selector '.review-likes-count', text: '1'
      expect(page).to have_selector('.liked')
    end

    it '「いいね」解除ボタンをクリックしたらlikesテーブルのレコードが一つ減ること' do
      expect{find('.liked').click}.to change { Like.count }.by(-1)
    end

    it 'あるユーザーが「いいね」した場合でも、別のユーザーでサインインすると「いいね」ボタンが表示されており、いいね解除ボタンが表示されないこと' do
      other_user = create(:user)
      sign_in other_user
      visit restaurant_path(restaurant, review)
      expect(page).to have_selector('.unliked')
      expect(page).to have_selector '.review-likes-count', text: '1'
      expect(page).to have_no_selector('.liked')
    end
  end

  context '自分が投稿した口コミの場合' do
    before do
      sign_in user
    end

    it '店舗詳細画面で、自分が投稿した口コミの「いいね」ボタンをクリックしてもlikesテーブルのレコード数が変化しないこと' do
      visit restaurant_path(another_restaurant, my_review)
      expect(user.own?(my_review)).to be true
      expect(find('.review-user-name').text).to eq(user.name)
      expect{find('.like-button-container').click}.to change { Like.count }.by(0)
    end

    it '自分が投稿した口コミ詳細画面に「いいね」ボタンは表示されず、編集・削除ボタンが表示されていること' do
      visit restaurant_review_path(restaurant_id: another_restaurant.id, id: my_review.id)
      expect(page).to have_link('編集')
      expect(page).to have_link('削除')
      expect(page).to have_no_selector('.like-button-container')
      expect(page).to have_no_selector('.unliked')
      expect(page).to have_no_selector('.liked')
      expect(page).to have_no_selector '.review-likes-count', text: '0'
    end

    it 'マイページで、投稿した口コミの「いいね」をクリックしてもlikesテーブルのレコード数が変化しないこと' do
      visit profile_path(my_review)
      expect{find('.like-button-container').click}.to change { Like.count }.by(0)
    end
  end

  context 'ログインしていない場合' do
    it 'ログインしていないユーザーが口コミ投稿のある店舗の詳細画面に遷移しても「いいね」ボタンが表示されないこと' do
      visit restaurant_path(restaurant, review)
      expect(page).to have_no_selector('.like-button-container')
      expect(page).to have_no_selector('.unliked')
      expect(page).to have_no_selector('.liked')
      expect(page).to have_no_selector '.review-likes-count', text: '0'
      expect(page).to have_content(review.menu)
      expect(page).to have_content(review.price)
      expect(page).to have_content(review.user.name)
    end

    it 'ログインしていないユーザーが口コミ詳細画面に遷移しても「いいね」ボタンが表示されないこと' do
      visit restaurant_review_path(restaurant_id: restaurant.id, id: review.id)
      expect(page).to have_no_selector('.like-button-container')
      expect(page).to have_no_selector('.unliked')
      expect(page).to have_no_selector('.liked')
      expect(page).to have_no_selector '.review-likes-count', text: '0'
    end
  end
end
