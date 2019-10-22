class DictionaryPageController < ApplicationController

  def create
    render html: "<script>alert('called')</script>".html_safe
    @word = Word.new(new_word_params)

    if @word.save
      render json: @word, status: :created
    else
      render json: @word.errors, status: :unprocessable_entity
    end
  end

  def new_word_params
    params.require(:word).permit(:rohkshe, :transliteration, :translation)
  end

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
