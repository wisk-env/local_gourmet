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

      it 'passwordとpassword_confirmationが一致しない場合は登録できないこと' do
        @user.password_confirmation = 'another_password'
        @user.valid?
        expect(@user.errors.full_messages).to include("パスワード（確認用） が一致しません")
      end
    end
  end

  describe 'ユーザーの関連付け' do
    before do
      @user = FactoryBot.create(:user)
    end

    it 'bookmarksとの関連付けが正しく設定されていること' do
      bookmark = FactoryBot.create(:bookmark, user: @user)
      expect(@user.bookmarks).to include bookmark
    end

    it 'reviewsとの関連付けが正しく設定されていること' do
      review = FactoryBot.create(:review, user: @user)
      expect(@user.reviews).to include review
    end

    it 'likesとの関連付けが正しく設定されていること' do
      like = FactoryBot.create(:like, user: @user)
      expect(@user.likes).to include like
    end
  end

  describe 'default_iconメソッドに関するテスト' do
    it 'ユーザーが新規登録された際にユーザーのデフォルト画像が設定されていること' do
      @user = FactoryBot.create(:user)
      expect(@user.avatar.filename).to eq('default_icon.png')
    end
  end

  describe 'ブックマークのメソッドに関するテスト' do
    before do
      @user = FactoryBot.create(:user)
      @restaurant = FactoryBot.create(:restaurant)
    end

    context 'bookmarkメソッドを呼び出した時' do
      it 'bookmarksテーブルに一つレコードが追加されていること' do
        expect { @user.bookmark(@restaurant) }.to change { Bookmark.count }.by(1)
      end
    end

    context 'unbookmarkメソッドを呼び出した時' do
      it 'bookmarksテーブルから一つレコードが削除されていること' do
        bookmark = FactoryBot.create(:bookmark, user: @user, restaurant: @restaurant)
        expect { @user.unbookmark(@restaurant) }.to change { Bookmark.count }.by(-1)
      end
    end

    context 'bookmark?メソッドを呼び出した時' do
      it 'ユーザーがお店をブックマークしていた場合は、trueを返すこと' do
        bookmark = FactoryBot.create(:bookmark, user: @user, restaurant: @restaurant)
        expect(@user.bookmark?(@restaurant)).to eq(true)
      end

      it 'ユーザーがお店をブックマークしていない場合は、falseを返すこと' do
        another_user = FactoryBot.create(:user)
        bookmark = FactoryBot.create(:bookmark, user: another_user, restaurant: @restaurant)
        expect(@user.bookmark?(@restaurant)).to eq(false)
      end
    end
  end

  describe 'ユーザーが口コミの投稿者であるか判定するメソッドのテスト' do
    before do
      @user = FactoryBot.create(:user)
    end

    it 'ユーザーが口コミの投稿者である場合はtrueを返すこと' do
      review = FactoryBot.create(:review, user: @user)
      expect(@user.own?(review)).to eq(true)
    end

    it 'ユーザーが口コミの投稿者でない場合はfalseを返すこと' do
      another_user = FactoryBot.create(:user)
      review = FactoryBot.create(:review, user: another_user)
      expect(@user.own?(review)).to eq(false)
    end
  end
end
