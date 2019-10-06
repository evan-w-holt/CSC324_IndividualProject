class Word < ApplicationRecord
  ROHKSHE_FORMAT_REGEX = /(\[\w{0,3}\+\w{1,2}\+\w{0,3}\])+/i

  validates :rohkshe, presence: true, format: { with: ROHKSHE_FORMAT_REGEX }
  validates :transliteration, presence: true
  validates :translation, presence: true
end
