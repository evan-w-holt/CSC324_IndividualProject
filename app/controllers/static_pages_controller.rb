class StaticPagesController < ApplicationController

  SAMPLE_ROHKSHE = {
    :Edigaul   => ["Edigaul", "[eh+d+][ih+g+][aw+l+]"],
    :Rohkshe   => ["Rohkshe", "[+r+][aw+k+][+sh+ee]"],
    :water     => ["ithni",   "[ih+th+][+n+ee]"],
    :river     => ["kuthni",  "[+k+uh][+th+][+n+ee]"],
    :ocean     => ["muuthni", "[+m+uuh][+th+][+n+ee]"],
    :'to have' => ["helai",   "[+h+][eh+l+ie]"],
    :'to be'   => ["ekai",    "[eh+k+ie]"],
    :hello     => ["osuuh",   "[oh+s+uuh]"],
    :goodbye   => ["vastin",  "[+v+][ah+s+][+t+][ih+n+]"],
    :I         => ["zai",     "[+z+ie]"],
    :you       => ["zo",      "[+z+oh]"],
    :one       => ["sikla",   "[+s+][ih+k+][+l+uh]"],
    :two       => ["pulta",   "[+p+][oo+l+][+t+uh]"],
    :three     => ["treena",  "[+t+][+r+ee][+n+uh]"],
    :this      => ["kish",    "[+k+][ih+sh+]"],
    :that      => ["kahsh",   "[+k+][ah+sh+]"],
    :and       => ["oh",      "[oh+sp+]"]
  }

  def home
    @translation = SAMPLE_ROHKSHE.keys.sample

    random_word = SAMPLE_ROHKSHE[@translation]
    @transliteration = random_word[0]
    @rohkshe = helpers.convert_rohkshe_string_into_array(random_word[1])
    @translation = @translation.to_s

    this_is_edigaul_and_rohkshe_unconverted = [
      Word.find_by(translation: "this").rohkshe,
      Word.find_by(translation: "to be").rohkshe,
      Word.find_by(translation: "Edigaul").rohkshe,
      Word.find_by(translation: "and").rohkshe,
      Word.find_by(translation: "Rohkshe").rohkshe
    ]
    @this_is_edigaul_and_rohkshe = this_is_edigaul_and_rohkshe_unconverted.map {
      |str| helpers.convert_rohkshe_string_into_array(str)
    }
  end

  def about
  end

  def help
  end
end
