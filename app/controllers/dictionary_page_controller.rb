class DictionaryPageController < ApplicationController
  def dictionary
    all_words = Word.all

    @all_words_displayable = []
    all_words.each do |word|
      displayable_word = []
      displayable_word << helpers.convert_rohkshe_string_into_array(word.rohkshe)
      displayable_word << word.transliteration
      displayable_word << word.translation

      @all_words_displayable << displayable_word
    end
  end
end
