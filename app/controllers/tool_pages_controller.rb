class ToolPagesController < ApplicationController
  
  @running_text = ""

  def new
    @text = ""
  end

  def create
    @text = letter_params
    @running_text += @text
    render :new
  end

  def index
    @text = ""
  end

  private
  def letter_params
    params.require(:letter)
  end

end
