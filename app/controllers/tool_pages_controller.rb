class ToolPagesController < ApplicationController

  def new
    @text = ""
    @edigaul_text = ""
    @edigaul_script = []
  end

  def create
    @text = letter_params
    
    text_converter = Converter.new(@text)
    @edigaul_text = text_converter.get_edigaul
    @edigaul_script = helpers.convert_rohkshe_string_into_array(@edigaul_text)

    render :index
  end

  def index
    @text = ""
    @edigaul_text = ""
    @edigaul_script = []
  end

  private
  def letter_params
    params.require(:text)
  end

end
