require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'ユーザー登録' do
    before do
      @user = FactoryBot.build(:user)
    end
  
    context 'ユーザー登録ができる時' do
      it 'name、email、password、password_confirmationが存在すれば登録できること' do
        expect(@user).to be_valid
      end
    end

    context 'ユーザー登録ができない時' do
      it 'nameが空の場合は登録できないこと' do
        @user.name = nil
        @user.valid?
        expect(@user.errors.full_messages).to include("ユーザー名 を入力してください")
      end

      it 'emailが空の場合は登録できないこと' do
        @user.email = nil
        @user.valid?
        expect(@user.errors.full_messages).to include("メールアドレス を入力してください")
      end

      it '既に登録されているemailの場合はユーザー登録できないこと' do
        @user.save
        another_user = FactoryBot.build(:user, email: @user.email)
        another_user.valid?
        expect(another_user.errors.full_messages).to include("メールアドレス は既に登録されています")
      end

      it 'passwordが空の場合は登録できないこと' do
        @user.password = nil
        @user.valid?
        expect(@user.errors.full_messages).to include("パスワード を入力してください")
      end

      it 'passwordが5文字以下の場合は登録できないこと' do
        @user.password = '12345'
        @user.valid?
        expect(@user.errors.full_messages).to include("パスワード は6文字以上で設定してください")
      end

      it 'password_confirmationが空の場合は登録できないこと' do
        @user.password_confirmation = nil
        @user.valid?
        expect(@user.errors.full_messages).to include("パスワード（確認用） を入力してください")
      end

      it 'passwordとpassword_confirmationが一致しない場合は登録できないこと' do
        @user.password_confirmation = 'another_password'
        @user.valid?
        expect(@user.errors.full_messages).to include("パスワード（確認用） が一致しません")
      end
    end
  end
end
