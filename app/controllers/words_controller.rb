class WordsController < ApplicationController

  def new
    @word = Word.new
  end

  def create
    @word = Word.new(new_word_params)

    if @word.save
      redirect_to @word
    else
      render 'new'
    end
  end

  def new_word_params
    params.require(:word).permit(:rohkshe, :transliteration, :translation)
  end

  def index
    @word = Word.new
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

  render 'new'
end
