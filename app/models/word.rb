class Word < ApplicationRecord
  before_save { self.rohkshe = rohkshe.downcase }

  ROHKSHE_FORMAT_REGEX = /\A(\[\w{0,3}\+\w{1,2}\+\w{0,3}\])+\z/i

  validates :rohkshe, presence: true, format: { with: ROHKSHE_FORMAT_REGEX }
  validates :transliteration, presence: true
  validates :translation, presence: true
end
