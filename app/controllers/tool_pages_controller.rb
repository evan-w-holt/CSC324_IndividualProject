class ToolPagesController < ApplicationController

  def new
    @text = ""
    @edigaul_text = ""
  end

  def create
    @text = letter_params

    text_converter = Converter.new(@text)
    @edigaul_text = text_converter.getEdigaul

    render :index
  end

  def index
    @text = ""
    @edigaul_text = ""
  end

  private
  def letter_params
    params.require(:letter)
  end

end
