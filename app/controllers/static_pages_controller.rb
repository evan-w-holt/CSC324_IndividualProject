class StaticPagesController < ApplicationController

  def convert_rohkshe_string_into_array(rohkshe_string)
    working_array = []

    letter_strings = rohkshe_string.split("]")
    letter_strings.each do |letter_string|
      # Remove the first character, which is always just [
      letter = letter_string[1..-1]

      letter_array = []

      if letter[0] == "+"
        letter_array << nil
      end

      # Note to self: reject(&:empty?) removes any empty strings in the array
      symbols = letter.split("+").reject(&:empty?)
      symbols.each do |symbol|
        letter_array << symbol
      end

      if letter[-1] == "+"
        letter_array << nil
      end

      working_array << letter_array
    end

    return working_array
  end

  SAMPLE_ROHKSHE = {
    :Edigaul => ["Edigaul", "[eh+d+][ih+g+][aw+l+]"],
    :Rohkshe => ["Rohkshe", "[+r+][aw+k+][+sh+ee]"],
    :water => ["ithni", "[ih+th+][+n+ee]"],
    :river => ["kuthni", "[+k+uh][+th+][+n+ee]"],
    :ocean => ["muuthni", "[+m+uuh][+th+][+n+ee]"],
    :'to have' => ["helai", "[+h+][eh+l+ie]"],
    :'to be' => ["ekai", "[eh+k+ie]"],
    :hello => ["oyseh", "[oh+y+][+s+eh]"],
    :goodbye => ["vastin", "[+v+][ah+s+][+t+][ih+n+]"],
    :I => ["zai", "[+z+ie]"],
    :you => ["zo", "[+z+oh]"],
    :one => ["sikla", "[+s+][ih+k+][+l+uh]"],
    :two => ["pulta", "[+p+][oo+l+][+t+uh]"],
    :three => ["treena", "[+t+][+r+ee][+n+uh]"],
    :this => ["kish", "[+k+][ih+sh+]"],
    :that => ["kahsh", "[+k+][ah+sh+]"],
    :and => ["oh", "[oh+sp+]"]
  }

  def home
    @translation = SAMPLE_ROHKSHE.keys.sample

    random_word = SAMPLE_ROHKSHE[@translation]
    @transliteration = random_word[0]
    @rohkshe = convert_rohkshe_string_into_array(random_word[1])
    @translation = @translation.to_s

    this_is_edigaul_and_rohkshe_unconverted = [
      Word.find_by(translation: "this").rohkshe,
      Word.find_by(translation: "to be").rohkshe,
      Word.find_by(translation: "Edigaul").rohkshe,
      Word.find_by(translation: "and").rohkshe,
      Word.find_by(translation: "Rohkshe").rohkshe
    ]
    @this_is_edigaul_and_rohkshe = this_is_edigaul_and_rohkshe_unconverted.map {
      |str| convert_rohkshe_string_into_array(str)
    }
  end

  def about
  end

  def help
  end
end
