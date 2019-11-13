class Word < ApplicationRecord
  before_save { self.rohkshe = rohkshe.downcase }

  ROHKSHE_FORMAT_REGEX = /\A(\[\w{0,3}\+\w{1,2}\+\w{0,3}\])+\z/i
  VALID_LETTERS_REGEX = /\A(\W*(eh|ee|ah|aah|aw|ay|uh|uuh|oh|oo|ih|ie)?\W+(b|d|f|g|h|j|k|l|m|n|p|r|s|t|v|w|y|z|sh|ch|th|zh|x})\W+(eh|ee|ah|aah|aw|ay|uh|uuh|oh|oo|ih|ie)?\W*)+\z/i

  validates :rohkshe, presence: true, format: {
    with: ROHKSHE_FORMAT_REGEX,
    message: "invalid, each letter should look like: [<vowel/empty>+<consonant>+<vowel/empty>]"
  }
  validates :rohkshe, format: {
    with: VALID_LETTERS_REGEX,
    message: "invalid, some vowels or consonants are not valid"
  }
  validates :transliteration, presence: true
  validates :translation, presence: true
end
