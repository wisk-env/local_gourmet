require 'rails_helper'

RSpec.describe "Users", type: :system do
  context 'ユーザー登録に成功する時' do
    before do
      visit new_user_registration_path
    end

    it "ユーザー登録画面でフォームに必要事項を入力して登録ボタンを押したらホーム画面に遷移すること" do
      fill_in 'ユーザー名', with: 'test_user'
      fill_in 'メールアドレス', with: 'test_user@example.com'
      fill_in 'パスワード', with: 'password'
      fill_in 'パスワード（確認用）', with: 'password'
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

    it "全てのフォームを入力せず登録ボタンを押したらユーザー登録に失敗すること" do
      fill_in 'ユーザー名', with: ''
      fill_in 'メールアドレス', with: ''
      fill_in 'パスワード', with: ''
      fill_in 'パスワード（確認用）', with: ''
      expect{find('input[name="commit"]').click}.to change { User.count }.by(0)
      expect(current_path).to eq('/users')
      expect(page).to have_content('ユーザー名 を入力してください')
      expect(page).to have_content('メールアドレス を入力してください')
      expect(page).to have_content('パスワード を入力してください')
    end

    it "既に登録されているメールアドレスを入力して登録ボタンを押したらユーザー登録に失敗すること" do
      user = FactoryBot.create(:user, email: 'test_user@example.com')
      fill_in 'ユーザー名', with: 'test_user'
      fill_in 'メールアドレス', with: user.email
      fill_in 'パスワード', with: 'password'
      fill_in 'パスワード（確認用）', with: 'password'
      expect{find('input[name="commit"]').click}.to change { User.count }.by(0)
      expect(current_path).to eq('/users')
      expect(find('.error-message-list')).to have_content('メールアドレス は既に登録されています')
    end

    it '5文字以下のパスワードを入力して登録ボタンを押したらユーザー登録に失敗すること' do
      fill_in 'ユーザー名', with: 'test_user'
      fill_in 'メールアドレス', with: 'test_user@example.com'
      fill_in 'パスワード', with: '12345'
      fill_in 'パスワード（確認用）', with: 'password'
      expect{find('input[name="commit"]').click}.to change { User.count }.by(0)
      expect(current_path).to eq('/users')
      expect(page).to have_content('パスワード は6文字以上で設定してください')
    end

    it 'パスワードとパスワード（確認用）が一致しない場合はユーザー登録できないこと' do
      fill_in 'ユーザー名', with: 'test_user'
      fill_in 'メールアドレス', with: 'test_user@example.com'
      fill_in 'パスワード', with: 'password'
      fill_in 'パスワード（確認用）', with: 'another_password'
      expect{find('input[name="commit"]').click}.to change { User.count }.by(0)
      expect(current_path).to eq('/users')
      expect(page).to have_content('パスワード（確認用） が一致しません')
    end
  end

  context 'ログインに成功する時' do
    let(:user) { create(:user) }

    it "ログイン画面でフォームに必要事項を入力してログインボタンを押したらホーム画面に遷移すること" do
      visit new_user_session_path
      fill_in 'メールアドレス', with: user.email
      fill_in 'パスワード', with: user.password
      click_button 'ログイン'
      expect(current_path).to eq(root_path)
      expect(find('.header-end')).to have_content(user.name)
      expect(find('.header-end')).to have_content('ログアウト')
    end
  end

  context 'ログインに失敗する時' do
    let(:user) { create(:user) }

    it "メールアドレスとパスワードを入力せずログインボタンを押したらログインに失敗すること" do
      visit new_user_session_path
      fill_in 'メールアドレス', with: ''
      fill_in 'パスワード', with: ''
      click_button 'ログイン'
      expect(current_path).to eq(new_user_session_path)
      expect(page).to have_content('メールアドレスまたはパスワードが違います')
    end
  end

  context 'ログインしている時' do
    let(:user) { create(:user) }

    before do
      sign_in user
      visit profile_path
    end

    it 'マイページにユーザー名とユーザーのメールアドレスとデフォルト画像が表示されていること' do
      expect(page).to have_content(user.name)
      expect(page).to have_content(user.email)
      expect(page).to have_selector("img[src$='default_icon.png']")
    end

    it 'プロフィール編集ボタンをクリックしたらプロフィール編集画面を表示できること' do
      click_link 'プロフィール編集'
      expect(current_path).to eq(edit_user_registration_path)
    end

    it 'プロフィールを編集して更新ボタンをクリックしたらプロフィール情報が編集されていること' do
      click_link 'プロフィール編集'
      fill_in 'ユーザー名', with: 'update_user'
      fill_in 'メールアドレス', with: 'update_user@example.com'
      attach_file 'プロフィール写真', "spec/fixtures/image/test_image.jpg"
      click_button 'プロフィール更新'
      expect(current_path).to eq(profile_path)
      expect(page).to have_content('アカウント情報を変更しました。')
      expect(page).to have_content('update_user')
      expect(page).to have_content('update_user@example.com')
      expect(page).to have_selector("img[src$='test_image.jpg']")
    end

    it '口コミ投稿へ遷移するリンクをクリックしたら口コミ投稿するお店を検索する画面が表示されていること' do
      click_link '口コミ投稿'
      expect(current_path).to eq(restaurant_registered_statuses_path)
      expect(page).to have_content('口コミを投稿したいお店を検索')
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
