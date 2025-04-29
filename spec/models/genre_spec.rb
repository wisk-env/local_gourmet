require 'rails_helper'

RSpec.describe Genre, type: :model do
  let(:genre) { build(:genre) }

  context 'genresテーブルにデータを保存できる時' do
    it 'nameがあれば保存できること' do
      expect(genre).to be_valid
    end
  end

  context 'genresテーブルにデータを保存できない時' do
    it 'nameが空の場合は保存できないこと' do
      genre.name = nil
      genre.valid?
      expect(genre.errors.full_messages).to include "ジャンル名 を入力してください"
    end
  end

  context 'Genreの関連付け' do
    it 'review_genresとの関連付けが正しく設定されていること' do
      genre.save
      review_genre = create(:review_genre, genre_id: genre.id)
      expect(genre.review_genres).to include review_genre
    end
  end
end
