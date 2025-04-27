require 'rails_helper'

RSpec.describe "Bookmarks", type: :system do
  before do
    driven_by(:rack_test)
    @user = FactoryBot.create(:user)
    @restaurant = FactoryBot.create(:restaurant)
    sign_in @user
  end

  it 'レストランの詳細ページに遷移したらブックマークボタンがあること' do
    visit restaurant_path(@restaurant)
    expect(page).to have_link('ブックマーク')
  end

  it 'ブックマークボタンをクリックしたらbookmarksテーブルのレコードが一つ増えること' do
    visit restaurant_path(@restaurant)
    expect{click_link('ブックマーク')}.to change { Bookmark.count }.by(1)
  end

  it '既にブックマークしている場合は、ブックマーク解除ボタンが表示されること' do
    bookmark = FactoryBot.create(:bookmark, user_id: @user.id, restaurant_id: @restaurant.id)
    visit restaurant_path(@restaurant)
    expect(page).to have_link('ブックマーク解除')
  end

  it 'ブックマーク解除ボタンをクリックしたらbookmarksテーブルのレコードが一つ減ること' do
    bookmark = FactoryBot.create(:bookmark, user_id: @user.id, restaurant_id: @restaurant.id)
    visit restaurant_path(@restaurant)
    binding.irb
    expect{click_link('ブックマーク解除')}.to change { Bookmark.count }.by(-1)
    binding.irb
  end
end
