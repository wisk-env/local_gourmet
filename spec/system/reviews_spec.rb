require 'rails_helper'

RSpec.describe "Reviews", type: :system do
  before do
    driven_by(:rack_test)
  end

  let(:user) { create(:user) }
  let(:restaurant) { create(:restaurant) }

  context '口コミの新規作成に関するテスト' do
    it '店舗詳細画面の「口コミを投稿する」ボタンから口コミ投稿画面に遷移できること' do
      sign_in user
      visit restaurant_path(restaurant)
      click_link '口コミを投稿する→'
      expect(current_path).to eq(new_restaurant_review_path(restaurant))
    end

    it '口コミ投稿に成功したらreviewsテーブルのレコードが一つ増えて、店舗詳細画面に遷移して口コミの「メニュー」と「料金」が表示されること' do
      sign_in user
      visit new_restaurant_review_path(restaurant)
      fill_in '注文したメニュー', with: 'test_food'
      fill_in '料金', with: '1000'
      fill_in 'ご利用人数', with: '1'
      expect{find('.submit-btn').click}.to change { Review.count }.by(1)
      expect(current_path).to eq(restaurant_path(restaurant))
      expect(page).to have_content '口コミを投稿しました'
      expect(page).to have_content 'test_food'
      expect(page).to have_content '¥ 1000'
    end

    it '画像をアップロードして口コミ投稿に成功したら店舗詳細画面でアップロードした画像が表示されて「NO IMAGE」が表示されないこと' do
      sign_in user
      visit new_restaurant_review_path(restaurant)
      fill_in '注文したメニュー', with: 'test_food'
      fill_in '料金', with: '1000'
      attach_file 'review[image]', "spec/fixtures/image/test_image.jpg"
      fill_in 'ご利用人数', with: '1'
      click_on '上記内容で口コミを投稿する'
      expect(page).to have_selector("img[src$='test_image.jpg']")
      expect(page).to have_no_content 'NO IMAGE'
    end

    it '口コミ投稿に失敗したらreviewsテーブルのレコード数は変化せず、入力が必要な項目のエラーが表示されること' do
      sign_in user
      visit new_restaurant_review_path(restaurant)
      fill_in '注文したメニュー', with: ''
      fill_in '料金', with: ''
      fill_in 'ご利用人数', with: ''
      expect{find('.submit-btn').click}.to change { Review.count }.by(0)
      expect(current_path).to eq("/restaurants/#{restaurant.id}/reviews")
      expect(page).to have_content '口コミ投稿に失敗しました'
      expect(page).to have_content '注文したメニュー を入力してください'
      expect(page).to have_content '料金 を入力してください'
      expect(page).to have_content 'ご利用人数 を入力してください'
    end
  end

  context '口コミ表示に関するテスト' do
    let(:review) { create(:review, restaurant_id: restaurant.id) }
    let(:my_review) { create(:review, user_id: user.id, restaurant_id: restaurant.id) }
    let(:another_user) { create(:user) }
    let(:another_user_review) { create(:review, price: 1500, user_id: another_user.id, restaurant_id: restaurant.id) }

    it '店舗詳細画面に、投稿した口コミの「メニュー」と「料金」が表示されること' do
      sign_in user
      visit restaurant_path(restaurant, review)
      expect(page).to have_content(review.menu)
      expect(page).to have_content(review.price)
    end

    it '店舗詳細画面に投稿されている口コミをクリックしたら口コミの詳細画面に遷移すること' do
      sign_in user
      visit restaurant_path(restaurant, review)
      first('.review-link').click
      expect(current_path).to eq(restaurant_review_path(restaurant, review))
    end

    it '口コミの詳細画面に投稿者名やmenu, price, visit_date, visit_time, number_of_visitorsなどの情報が表示されること' do
      sign_in user
      visit restaurant_review_path(restaurant, review)
      expect(page).to have_content(review.user.name)
      expect(page).to have_content(review.menu)
      expect(page).to have_content("¥ #{review.price}")
      expect(page).to have_content("#{review.visit_date} #{review.visit_time}の時間帯に #{review.number_of_visitors} 名で利用")
      expect(page).to have_content(review.comment)
    end

    it '自分が投稿した口コミの詳細画面では編集ボタンと削除ボタンが表示されていること' do
      sign_in user
      visit restaurant_review_path(restaurant, my_review)
      expect(page).to have_content('編集')
      expect(page).to have_content('削除')
    end

    it '投稿した口コミがマイページに表示されていること' do
      sign_in user
      visit profile_path(my_review)
      find('.tab-list').find('.my-review').click
      expect(page).to have_content(my_review.menu)
      expect(page).to have_content(my_review.price)
    end

    it '他のユーザーが投稿した口コミはマイページに表示されていないこと' do
      sign_in user
      visit profile_path(my_review)
      find('.tab-list').find('.my-review').click
      expect(page).to have_no_content(another_user_review.menu)
      expect(page).to have_no_content(another_user_review.price)
    end
  end

  context '口コミ編集に関するテスト' do
    before do
      sign_in user
    end

    let(:my_review) { create(:review, user_id: user.id) }

    it '口コミ詳細画面の「編集」ボタンをクリックしたら口コミ編集画面に遷移すること' do
      visit restaurant_review_path(restaurant, my_review)
      click_link '編集'
      expect(current_path).to eq(edit_restaurant_review_path(restaurant, my_review))
    end

    it '口コミの更新に成功したら、口コミの詳細画面に遷移して「メニュー」と「料金」が表示され、reviewsテーブルのレコード数は変化しないこと' do
      visit edit_restaurant_review_path(restaurant, my_review)
      fill_in '注文したメニュー', with: 'test_food_update'
      fill_in '料金', with: '4000'
      fill_in 'ご利用人数', with: '2'
      expect{find('.submit-btn').click}.to change { Review.count }.by(0)
      expect(current_path).to eq(restaurant_review_path(restaurant, my_review))
      expect(page).to have_content '口コミを更新しました'
      expect(page).to have_content 'test_food_update'
      expect(page).to have_content '¥ 4000'
    end

    it '口コミ投稿に失敗したらreviewsテーブルのレコード数は変化せず、入力が必要な項目のエラーが表示されること' do
      visit edit_restaurant_review_path(restaurant, my_review)
      fill_in '注文したメニュー', with: ''
      fill_in '料金', with: ''
      fill_in 'ご利用人数', with: ''
      expect{find('.submit-btn').click}.to change { Review.count }.by(0)
      expect(current_path).to eq(restaurant_review_path(restaurant, my_review))
      expect(page).to have_content '口コミの更新に失敗しました'
      expect(page).to have_content '注文したメニュー を入力してください'
      expect(page).to have_content '料金 を入力してください'
      expect(page).to have_content 'ご利用人数 を入力してください'
    end
  end

  context '口コミ削除に関するテスト' do
    let(:my_review) { create(:review, user_id: user.id) }
    
    it '口コミ詳細画面の「削除」ボタンをクリックしたら、ユーザーが投稿した口コミの件数が1つ減ること' do
      sign_in user
      visit restaurant_review_path(restaurant, my_review)
      expect(user.reviews.count).to eq 1
      find('.destroy-color').click
      accept_alert
      expect(current_path).to eq(restaurant_path(restaurant))
      expect(page).to have_content '口コミを削除しました'
      expect(user.reviews.count).to eq 0
    end
  end
end
