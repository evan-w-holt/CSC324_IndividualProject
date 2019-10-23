class Word < ApplicationRecord
  before_save { self.rohkshe = rohkshe.downcase }

  ROHKSHE_FORMAT_REGEX = /\A(\[\w{0,3}\+\w{1,2}\+\w{0,3}\])+\z/i

  validates :rohkshe, presence: true, format: {
    with: ROHKSHE_FORMAT_REGEX,
    message: "invalid, each letter should look like: [<vowel/empty>+<consonant>+<vowel/empty>]"
  }
  validates :transliteration, presence: true
  validates :translation, presence: true
end
