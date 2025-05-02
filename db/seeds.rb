# frozen_string_literal: true

FeedbackOption.create([
  { option_title: 'にぎやか' },
  { option_title: '落ち着いて食事ができる' },
  { option_title: 'グループ来店多め' },
  { option_title: '一人での来店も多い' },
  { option_title: '男性に人気' },
  { option_title: '女性に人気' },
  { option_title: '席が広い' },
  { option_title: '個室あり' },
  { option_title: '料理の提供が早い' },
  { option_title: '現金のみ' },
  { option_title: 'カード決済可' },
  { option_title: 'QRコード決済可' }
])

Genre.create([
  { name: '和食' },
  { name: '洋食' },
  { name: '中華料理' },
  { name: '韓国料理' },
  { name: 'イタリアン' },
  { name: '地中海料理' },
  { name: 'インド料理' },
  { name: 'タイ料理' },
  { name: 'ベトナム料理' },
  { name: 'お寿司' },
  { name: '焼肉' },
  { name: '焼き鳥' },
  { name: '丼もの' },
  { name: '粉もの' },
  { name: 'うどん' },
  { name: 'そば' },
  { name: 'カレー' },
  { name: 'ピザ' },
  { name: 'パスタ' },
  { name: 'ハンバーガー' },
  { name: 'ラーメン' },
  { name: '居酒屋' },
  { name: 'サラダ' },
  { name: 'カフェ' }
])
