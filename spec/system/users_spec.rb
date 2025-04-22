require 'rails_helper'

RSpec.describe "Users", type: :system do
  before do
    driven_by(:rack_test)  
  end

  context 'ユーザー登録に成功する時' do
    before do
      visit new_user_registration_path
    end

    it "ユーザー登録画面でフォームに必要事項を入力して登録ボタンを押したらホーム画面に遷移すること" do
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

  context 'ユーザー登録に失敗する時' do
    before do
      visit new_user_registration_path
    end

    it "名前を入力せず登録ボタンを押したらユーザー登録に失敗すること" do
      fill_in 'user[name]', with: ''
      fill_in 'user[email]', with: 'test_user@example.com'
      fill_in 'user[password]', with: 'password'
      fill_in 'user[password_confirmation]', with: 'password'
      expect{find('input[name="commit"]').click}.to change { User.count }.by(0)
      expect(current_path).to eq('/users')
      expect(find('.error-message-list')).to have_content('ユーザー名 を入力してください')
    end

    it "メールアドレスを入力せず登録ボタンを押したらユーザー登録に失敗すること" do
      fill_in 'user[name]', with: 'test_user'
      fill_in 'user[email]', with: ''
      fill_in 'user[password]', with: 'password'
      fill_in 'user[password_confirmation]', with: 'password'
      expect{find('input[name="commit"]').click}.to change { User.count }.by(0)
      expect(current_path).to eq('/users')
      expect(find('.error-message-list')).to have_content('メールアドレス を入力してください')
    end

    it "既に登録されているメールアドレスを入力して登録ボタンを押したらユーザー登録に失敗すること" do
      user = FactoryBot.create(:user, email: 'test_user@example.com')
      fill_in 'user[name]', with: 'test_user'
      fill_in 'user[email]', with: user.email
      fill_in 'user[password]', with: 'password'
      fill_in 'user[password_confirmation]', with: 'password'
      expect{find('input[name="commit"]').click}.to change { User.count }.by(0)
      expect(current_path).to eq('/users')
      expect(find('.error-message-list')).to have_content('メールアドレス は既に登録されています')
    end

    it "パスワードを入力せず登録ボタンを押したらユーザー登録に失敗すること" do
      fill_in 'user[name]', with: 'test_user'
      fill_in 'user[email]', with: 'test_user@example.com'
      fill_in 'user[password]', with: ''
      fill_in 'user[password_confirmation]', with: 'password'
      expect{find('input[name="commit"]').click}.to change { User.count }.by(0)
      expect(current_path).to eq('/users')
      expect(page).to have_content('パスワード を入力してください')
    end

    it '5文字以下のパスワードを入力して登録ボタンを押したらユーザー登録に失敗すること' do
      fill_in 'user[name]', with: 'test_user'
      fill_in 'user[email]', with: 'test_user@example.com'
      fill_in 'user[password]', with: '12345'
      fill_in 'user[password_confirmation]', with: 'password'
      expect{find('input[name="commit"]').click}.to change { User.count }.by(0)
      expect(current_path).to eq('/users')
      expect(page).to have_content('パスワード は6文字以上で設定してください')
    end

    it "パスワード（確認用）を入力せず登録ボタンを押したらユーザー登録に失敗すること" do
      fill_in 'user[name]', with: 'test_user'
      fill_in 'user[email]', with: 'test_user@example.com'
      fill_in 'user[password]', with: 'password'
      fill_in 'user[password_confirmation]', with: ''
      expect{find('input[name="commit"]').click}.to change { User.count }.by(0)
      expect(current_path).to eq('/users')
      expect(page).to have_content('パスワード（確認用） を入力してください')
    end

    it 'パスワードとパスワード（確認用）が一致しない場合はユーザー登録できないこと' do
      fill_in 'user[name]', with: 'test_user'
      fill_in 'user[email]', with: 'test_user@example.com'
      fill_in 'user[password]', with: 'password'
      fill_in 'user[password_confirmation]', with: 'another_password'
      expect{find('input[name="commit"]').click}.to change { User.count }.by(0)
      expect(current_path).to eq('/users')
      expect(page).to have_content('パスワード（確認用） が一致しません')
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

  context 'ログインに失敗する時' do
    it "メールアドレスとパスワードを入力せずログインボタンを押したらログインに失敗すること" do
      @user = FactoryBot.create(:user)
      visit new_user_session_path
      fill_in 'メールアドレス', with: ''
      fill_in 'パスワード', with: ''
      click_button 'ログイン'
      expect(current_path).to eq(new_user_session_path)
      expect(find('.flash-message')).to have_content('メールアドレスまたはパスワードが違います')
    end
  end

  context 'ログインしていない時' do
    before do
      visit root_path
    end

    it '口コミ投稿のリンクを押すとログインページにリダイレクトされること' do
      click_link '口コミを投稿する'
      expect(current_path).to eq(new_user_session_path)
    end
  
    it 'マイページのリンクを押すとログインページにリダイレクトされること' do
      click_link 'マイページ'
      expect(current_path).to eq(new_user_session_path)
    end
  end
end
