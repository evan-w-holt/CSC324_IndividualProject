class ToolPagesController < ApplicationController

  def new
    @text = ""
    @edigaul_text = ""
    @edigaul_script = []
  end

  def create
    @text = letter_params

    if (@text[-1] == "-")
      backspace
    end
    
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

    def backspace
      # Remove the backspace marker and any morpheme breaks that are the last letters
      # Remove the morpheme breaks to prevent "nothing happened" situation if morpheme breaks are at the end
      @text = @text.delete_suffix(",-")
      while (@text.delete_suffix!(",/"))
      end

      last_comma = @text.rindex(",")
      if (last_comma)
        @text = @text[0..last_comma]
      else
        @text = ""
      end
    end
end
