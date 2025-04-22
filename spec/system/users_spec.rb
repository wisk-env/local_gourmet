require 'rails_helper'

RSpec.describe "Users", type: :system do
  before do
    driven_by(:rack_test)  
  end

  context 'ユーザー登録に成功する時' do
    it "ユーザー登録画面でフォームに必要事項を入力して登録ボタンを押したらホーム画面に遷移すること" do
      visit new_user_registration_path
      fill_in 'user[name]', with: 'test_user'
      fill_in 'user[email]', with: 'test_user@example.com'
      fill_in 'user[password]', with: 'password'
      fill_in 'user[password_confirmation]', with: 'password'
      expect{find('input[name="commit"]').click}.to change { User.count }.by(1)
      expect(current_path).to eq(root_path)
      expect(find('.header-end')).to have_content('test_user')
      expect(find('.header-end')).to have_content('ログアウト')
    end
  end

  context 'ログインに成功する時' do
    it "ログイン画面でフォームに必要事項を入力してログインボタンを押したらホーム画面に遷移すること" do
      @user = FactoryBot.create(:user)
      visit new_user_session_path
      fill_in 'メールアドレス', with: @user.email
      fill_in 'パスワード', with: @user.password
      click_button 'ログイン'
      expect(current_path).to eq(root_path)
      expect(find('.header-end')).to have_content(@user.name)
      expect(find('.header-end')).to have_content('ログアウト')
    end
  end

  context 'ログインしていない時' do
    it '口コミ投稿のリンクを押すとログインページにリダイレクトされること' do
      visit root_path
      click_link '口コミを投稿する'
      expect(current_path).to eq(new_user_session_path)
    end
  
    it 'マイページのリンクを押すとログインページにリダイレクトされること' do
      visit root_path
      click_link 'マイページ'
      expect(current_path).to eq(new_user_session_path)
    end
  end
end
