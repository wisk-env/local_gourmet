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

    it '口コミ投稿に成功したらreviewsテーブルのレコードが一つ増えて、店舗詳細画面に口コミの「メニュー」と「料金」が表示されること' do
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
end
