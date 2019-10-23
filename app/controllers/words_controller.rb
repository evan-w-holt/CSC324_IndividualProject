class WordsController < ApplicationController

  def new
    @word = Word.new
  end

  def create
    @word = Word.new(new_word_params)

    if @word.save
      flash[:success] = "Word \"#{@word.translation} / #{@word.transliteration}\" successfully added!"
      redirect_to words_url
    else
      render :new
    end
  end

  def destroy
    deleted_word = Word.find(params[:id]).destroy
    flash[:success] = "Word \"#{deleted_word.translation} / #{deleted_word.transliteration}\" successfully deleted!"
    redirect_to words_url
  end

  def index
    @word = Word.new
  end

  private
  def new_word_params
    params.require(:word).permit(:rohkshe, :transliteration, :translation)
  end
end
