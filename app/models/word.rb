class Word < ApplicationRecord
  before_save { self.rohkshe = rohkshe.downcase }

  ROHKSHE_FORMAT_REGEX = /\A(\[(eh|ee|ah|aah|aw|ay|uh|uuh|oh|oo|ih|ie)?\+(b|d|f|g|h|j|k|l|m|n|p|r|s|t|v|w|y|z|sh|ch|th|zh|x})\+(eh|ee|ah|aah|aw|ay|uh|uuh|oh|oo|ih|ie)?\])+\z/i

  validates :rohkshe, presence: true, format: {
    with: ROHKSHE_FORMAT_REGEX,
    message: "invalid, each letter should look like: [<vowel/empty>+<consonant>+<vowel/empty>]"
  }
  validates :transliteration, presence: true
  validates :translation, presence: true
end
