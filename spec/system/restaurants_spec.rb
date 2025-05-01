require 'rails_helper'

RSpec.describe "Restaurants", type: :system do
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  context '店舗が登録されていない場合 ' do
    it 'latとlngとaddressがある場合は、店舗登録画面が表示されること' do
      visit new_restaurant_path(lat: 35, lng: 139, address: '東京都千代田区丸の内1-9-1')
      expect(page).to have_content "店舗登録画面"
    end

    it 'latがない場合は、店舗登録画面ではなく口コミを投稿する店舗検索画面が表示されること' do
      visit new_restaurant_path(lat: nil, lng: 139, address: '東京都千代田区丸の内1-9-1')
      expect(current_path).not_to eq (new_restaurant_path)
      expect(page).to have_no_content "店舗登録画面"
      expect(current_path).to eq (restaurant_registered_statuses_path)
      expect(page).to have_content "口コミを投稿したいお店を検索"
    end

    it 'lngがない場合は、店舗登録画面ではなく口コミを投稿する店舗検索画面が表示されること' do
      visit new_restaurant_path(lat: 35, lng: nil, address: '東京都千代田区丸の内1-9-1')
      expect(current_path).not_to eq (new_restaurant_path)
      expect(page).to have_no_content "店舗登録画面"
      expect(current_path).to eq (restaurant_registered_statuses_path)
      expect(page).to have_content "口コミを投稿したいお店を検索"
    end

    it 'addressがない場合は、店舗登録画面ではなく口コミを投稿する店舗検索画面が表示されること' do
      visit new_restaurant_path(lat: 35, lng: 139, address: nil)
      expect(current_path).not_to eq (new_restaurant_path)
      expect(page).to have_no_content "店舗登録画面"
      expect(current_path).to eq (restaurant_registered_statuses_path)
      expect(page).to have_content "口コミを投稿したいお店を検索"
    end

    it '店舗登録画面で、お店の名前を入力して「店舗登録」ボタンをクリックしたら、店舗の詳細画面に遷移し、登録した飲食店名が表示されること' do
      visit new_restaurant_path(lat: 35, lng: 139, address: '東京都千代田区丸の内1-9-1')
      fill_in '飲食店名', with: '東京駅カフェ'
      expect(page).to have_button '店舗登録を完了する'
      expect{find('.registration-button').click}.to change { Restaurant.count }.by(1)
      expect(current_path).to eq(restaurant_path(Restaurant.last))
      expect(page).to have_content 'お店を登録しました。さっそくお店の口コミを投稿してみましょう。'
      expect(page).to have_content 'お店の詳細'
      expect(page).to have_content '東京駅カフェ'
      expect(page).to have_content '東京都千代田区丸の内1-9-1'
    end

    it '店舗登録画面で、お店の名前を入力せずに「店舗登録」ボタンをクリックしたら、店舗登録に失敗すること' do
      visit new_restaurant_path(lat: 35, lng: 139, address: '東京都千代田区丸の内1-9-1')
      fill_in '飲食店名', with: ''
      expect(page).to have_button '店舗登録を完了する'
      expect{find('.registration-button').click}.to change { Restaurant.count }.by(0)
      expect(current_path).to eq(new_restaurant_path)
      expect(page).to have_content 'お店の登録に失敗しました。飲食店名を入力して下さい。'
    end
  end

  context '店舗が既に登録されている場合' do
    before do
      @restaurant = create(:restaurant)
    end

    it 'latとlngのデータが既に登録されていた場合は、店舗が既に登録済みと画面に表示されること' do
      visit new_restaurant_registered_status_path(lat: @restaurant.lat, lng: @restaurant.lng, address: @restaurant.address)
      expect(current_path).to eq(restaurant_registered_status_path(@restaurant))
      expect(page).to have_content "以下のお店は既に登録されています。"
      expect(page).to have_content "飲食店名: #{@restaurant.name}"
      expect(page).to have_content "住所: #{@restaurant.address}"
    end

    it '店舗が登録済みであることが判定される画面で、「口コミを投稿する」ボタンをクリックしたら、口コミ投稿画面に遷移すること' do
      visit new_restaurant_registered_status_path(lat: @restaurant.lat, lng: @restaurant.lng, address: @restaurant.address)
      expect(page).to have_content "以下のお店は既に登録されています。"
      expect(page).to have_content("飲食店名: #{@restaurant.name}")
      expect(page).to have_content("住所: #{@restaurant.address}")
      click_link "口コミを投稿する"
      expect(current_path).to eq(new_restaurant_review_path(@restaurant))
      expect(page).to have_content '口コミ投稿画面'
    end

    it '既に登録済みの店舗については、URL直打ちした場合でも店舗登録画面にアクセスできず、店舗詳細画面にリダイレクトされること' do
      visit new_restaurant_path(lat: @restaurant.lat, lng: @restaurant.lng, address: @restaurant.address)
      expect(current_path).to eq(restaurant_path(@restaurant))
      expect(page).to have_content 'お店の詳細'
      expect(page).to have_content(@restaurant.name)
      expect(page).to have_content(@restaurant.address)
    end
  end
end
