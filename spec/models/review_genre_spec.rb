require 'rails_helper'

RSpec.describe ReviewGenre, type: :model do
  let(:review) { create(:review) }
  let(:genre) { create(:genre) }

  describe 'ReviewとGenreの中間テーブル' do
    context 'review_genresテーブルにデータを保存できる時' do
      it 'review_idとgenre_idがあれば保存できること' do
        review_genre = build(:review_genre, review_id: review.id, genre_id: genre.id)
        expect(review_genre).to be_valid
      end

      it 'review_idが同じでも、genre_idが異なれば保存できること' do
        review_genre = create(:review_genre, review_id: review.id, genre_id: genre.id)
        another_genre = create(:genre)
        another_review_genre = build(:review_genre, review_id: review.id, genre_id: another_genre.id)
        expect(another_review_genre).to be_valid
      end

      it 'genre_idが同じでも、review_idが異なれば保存できること' do
        review_genre = create(:review_genre, review_id: review.id, genre_id: genre.id)
        another_review = create(:review)
        another_review_genre = build(:review_genre, review_id: another_review.id, genre_id: genre.id)
        expect(another_review_genre).to be_valid
      end
    end

    context 'review_genresテーブルにデータを保存できない時' do
      it 'review_idが空だと保存できないこと' do
        review_genre = build(:review_genre, review_id: nil, genre_id: genre.id)
        review_genre.valid?
        expect(review_genre.errors.full_messages).to include "レビューID が必要です"
      end

      it 'genre_idが空だと保存できないこと' do
        review_genre = build(:review_genre, review_id: review.id, genre_id: nil)
        review_genre.valid?
        expect(review_genre.errors.full_messages).to include "ジャンルID が必要です"
      end

      it 'review_idとgenre_idの両方が同じデータが既に存在すれば保存できないこと' do
        review_genre = create(:review_genre, review_id: review.id, genre_id: genre.id)
        same_data = build(:review_genre, review_id: review.id, genre_id: genre.id)
        expect(same_data.valid?).to be false
      end
    end
  end
end
