require 'rails_helper'

RSpec.describe "Bookmarks", type: :system do
  let(:user) { create(:user) }
  let(:restaurant) { create(:restaurant) }

  context 'ブックマークしていない店舗の詳細画面に遷移した時' do
    before do
      sign_in user
      visit restaurant_path(restaurant)
    end

    it '店舗詳細画面に遷移したらブックマークボタンがあること' do
      expect(page).to have_link('ブックマーク')
    end
  
    it 'ブックマークボタンをクリックしたらbookmarksテーブルのレコードが一つ増えること' do
      expect{click_link('ブックマーク')}.to change { Bookmark.count }.by(1)
    end
  end

  context 'ブックマークした店舗の詳細画面に遷移した時' do
    before do
      bookmark = create(:bookmark, user_id: user.id, restaurant_id: restaurant.id)
      sign_in user
      visit restaurant_path(restaurant)
    end
  
    it '既にブックマークしている場合は、ブックマーク解除ボタンが表示されること' do
      expect(page).to have_link('ブックマーク解除')
    end
  
    it 'ブックマーク解除ボタンをクリックしたらbookmarksテーブルのレコードが一つ減ること' do
      expect{click_link('ブックマーク解除')}.to change { Bookmark.count }.by(-1)
    end

    it 'あるユーザーがブックマークした場合でも、別のユーザーでサインインするとブックマークボタンが表示されており、ブックマーク解除ボタンが表示されないこと' do
      another_user = FactoryBot.create(:user)
      sign_in another_user
      visit restaurant_path(restaurant)
      expect(page).to have_link('ブックマーク')
      expect(page).to have_no_link('ブックマーク解除')
    end
  end

  context 'マイページに遷移した時' do
    before do
      bookmark = create(:bookmark, user_id: user.id, restaurant_id: restaurant.id)
      sign_in user
      visit profile_path
    end

    it 'ブックマークした店舗がマイページに表示されていること' do
      expect(page).to have_content(restaurant.name)
      expect(page).to have_content(restaurant.address)
      expect(page).to have_no_content('保存したお店はまだありません。')
    end
  
    it 'マイページに他のユーザーがブックマークした店舗が表示されていないこと' do
      another_user = create(:user)
      sign_in another_user
      visit profile_path
      expect(page).to have_no_content(restaurant.name)
      expect(page).to have_no_content(restaurant.address)
      expect(page).to have_content('保存したお店はまだありません。')
    end
  end

  context 'ログインしていない時' do
    it 'ログインしていないユーザーが店舗詳細画面に遷移すると、ブックマークボタンが表示されないこと' do
      visit restaurant_path(restaurant)
      expect(page).to have_no_link('ブックマーク')
    end
  end
end
