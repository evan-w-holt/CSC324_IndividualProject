# I originally wrote this class in Java in December 2018
class Letter

  attr_reader :consonant, :uptail, :index

  def initialize(consonant, uptail, index)
    @consonant = "+#{consonant}+"
    @uptail = uptail
    @index = index
  end

  # Sets a vowel of this letter
  # If is_top is true, sets top vowel, otherwise sets bottom vowel
  def set_vowel(vowel, is_top)
    if (is_top)
      @top_vowel = vowel
    else
      @bottom_vowel = vowel
    end
  end

  # Determines if this letter is a morpheme break
  def is_morpheme_break
    return @consonant == "+/+"
  end

  # Determines if this letter is an x (Xerithian Z, which cannot take vowel marks)
  def is_x
    return @consonant == "+x+"
  end

  # Determines if a vowel is already filled
  # If is_top is true, checks top vowel, otherwise checks bottom vowel
  def vowel_available(is_top)
    if (is_top)
      return !@top_vowel
    else
      return !@bottom_vowel
    end
  end

  # Returns a string with the contents of the letter enclosed in brackets
  def get_full_letter
    if (is_morpheme_break)
      return ""
    else
      return "[#{@top_vowel}#{@consonant}#{@bottom_vowel}]"
    end
  end
end