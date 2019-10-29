# I originally wrote this class in Java in January 2019
class Letter

  def initialize(consonant, uptail, index)
    @consonant = "+#{consonant}+"
    @uptail = uptail
    @index = index
  end

  # Sets a vowel of this letter
  # If isTop is true, sets top vowel, otherwise sets bottom vowel
  def setVowel(vowel, isTop)
    if (isTop)
      @topVowel = vowel
    else
      @bottomVowel = vowel
    end
  end

  # Determines if this letter is a morpheme break
  def isMorphemeBreak
    return @consonant == "/"
  end

  # Determines if a vowel is already filled
  # If isTop is true, checks top vowel, otherwise checks bottom vowel
  def vowelAvailable(isTop)
    if (isTop)
      return !@topVowel
    else
      return !@bottomVowel
    end
  end

  # Returns a string with the contents of the letter enclosed in brackets
  def getFullLetter
    if (isMorphemeBreak)
      return ""
    else
      return "[#{@topVowel}#{@consonant}#{@bottomVowel}]"
    end
  end
end