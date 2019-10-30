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
      # Remove the backspace marker and a morpheme break if that is the last letter
      # Remove the morpheme break to prevent "nothing happened" situation if morpheme break was last letter
      @text = @text.delete_suffix(",-").delete_suffix(",/")

      last_comma = @text.rindex(",")
      if (last_comma)
        @text = @text[0..last_comma]
      else
        @text = ""
      end
    end
end
