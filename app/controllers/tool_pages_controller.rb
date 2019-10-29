class ToolPagesController < ApplicationController

  def new
    @text = ""
  end

  def create
    @text = letter_params
    render :index
  end

  def index
    @text = ""
  end

  private
  def letter_params
    params.require(:letter)
  end

end
