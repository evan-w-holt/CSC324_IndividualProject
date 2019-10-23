class WordsController < ApplicationController

  def new
    @word = Word.new
  end

  def create
    @word = Word.new(new_word_params)

    if @word.save
      redirect_to @word
    else
      render :new
    end
  end

  def show
    @word = Word.find(params[:id])
  end

  def index
    @word = Word.new
  end

  private
  def new_word_params
    params.require(:word).permit(:rohkshe, :transliteration, :translation)
  end
end
