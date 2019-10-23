class WordsController < ApplicationController

  def new
    @word = Word.new
  end

  def create
    @word = Word.new(new_word_params)

    if @word.save
      flash[:success] = "Word \"#{@word.translation} / #{@word.transliteration}\" successfully added!"
      redirect_to @word
    else
      flash[:word_errors] = @word.errors.full_messages
      redirect_back fallback_location: root_path
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
