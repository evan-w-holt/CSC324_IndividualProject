# I originally wrote this class in Java in January 2019
# It took one ugly string as input and spat out the string values I use in the
# words database to store the Rohkshe data (Ex: k,uh,/,th,n,ee => [+k+uh][+th+][+n+ee])
class Converter

  # Constants for top and bottom vowels
  TOP = true
  BOTTOM = false

  # Lists of uptail and downtail consonants
  UPTAILS = [
    "b", "d", "f", "g", "j", "k", "l", "r", "y", "sh", "x", "sp"
  ]
  DOWNTAILS = [
    "h", "m", "n", "p", "s", "t", "v", "w", "z", "ch", "th", "zh"
  ]

  # List of vowels
  VOWELS = [
    "eh", "ee", "ah", "aah", "aw", "ay", "uh", "uuh", "oh", "oo", "ih", "ie"
  ]

  MORPHEME_BREAK = "/"

  def initialize(input)
    @input = input.downcase
    @englishLetters = @input.split(",").reject(&:empty?)
    @englishVowels = {}
    @edigaulLetters = {}

    @englishLetters.each_with_index do |l, i|
      if (!VOWELS.include(l))
        isUptail = UPTAILS.include(l)

        # Ensure letter is valid
        if (!isUptail && !DOWNTAILS.include(l) && l != MORPHEME_BREAK)
          @error = "Invalid character #{l}"
          return
        end

        letter = Letter.new(l, isUptail, i.to_f)
        @edigaulLetters[i.to_f] = letter
      else
        @englishVowels[i.to_f] = l
      end
    end

    edigaulKeys = @edigaulLetters.keys.sort
    prevL = nil

    # Add the beginning and middle vowel marks
    edigaulKeys.each do |i|
      thisL = @edigaulLetters[i]

      starting = (prevL ? prevL.index + 1 : 0).floor
      ending = thisL.index.floor
      vowels = getVowels(starting, ending)

      firstL  = (!prevL || prevL.isMorphemeBreak || prevL.consonant == "x") ? nil : prevL
      secondL = (!thisL || thisL.isMorphemeBreak || thisL.consonant == "x") ? nil : thisL

      if (vowels.length > 0)
        success = assignVowels(firstL, secondL, vowels, (starting.to_f + ending) / 2)

        if (!success)
          @error = "Error assigning vowel marks between consonants #{prevL.consonant} and #{thisL.consonant}"
          return
        end
      end

      prevL = thisL
    end

    # Add the remaining vowel marks
    starting = (prevL ? prevL.index + 1 : 0).floor
    ending = -1
    vowels = getVowels(starting, ending)

    if (vowels.length > 0)
      success = assignVowels(prevL, nil, vowels, starting.to_f + 1)

      if (!success)
        @error "Error assigning vowel marks after consonant #{prevL.consonant}"
        return
      end
    end
  end

  # Gets the Edigaul that this converter object has generated from its input
  def getEdigaul
    if (@error)
      return @error
    else
      edigaul = ""

      letterKeysInOrder = @edigaulLetters.keys.sort
      letterKeysInOrder.each do |i|
        edigaul += @edigaulLetters[i].getFullLetter
      end

      return edigaul
    end
  end

  # Gets the vowels to be placed between two letters
  private
  def getVowels(starting, ending)
    vowels = []

    if (ending != -1)
      for i in starting..(ending - 1)
        v = @englishVowels[i]
        
        if (v)
          vowels << v
          @englishVowels.delete(i)
        end
      end
    else
      # Get all remaining vowels
      i = starting

      while (@englishVowels.length > 0)
        v = @englishVowels[i]
        
        if (v)
          vowels << v
          @englishVowels.delete(i)
        end

        i++
      end
    end

    return vowels
  end

  # Assigns vowels, returns whether or not the operation was successful
  private
  def assignVowels(firstL, secondL, vowels, midIndex)
    # Check vowel validity
    vowels.each do |vowel|
      if (!VOWELS.include(vowel))
        return false
      end
    end

    if (firstL && secondL)
      # Both letters can take vowel marks
      if (vowels.length == 1)
        return oneVowelTwoLetters(firstL, secondL, vowels[0])
      elsif (vowels.length == 2)
        return twoVowelsTwoLetters(firstL, secondL, vowels)
      else
        return multipleVowelsTwoLetters(firstL, secondL, vowels)
      end
    elsif (!firstL && !secondL)
      # Neither letter can take vowel marks, add placeholders (sp)
      return multipleVowelsNoLetters(midIndex, vowels)
    else
      # Only one letter can take vowel marks
      if (vowels.length == 1)
        return oneVowelOneLetter(firstL, secondL, vowels[0])
      else
        return multipleVowelsOneLetter(firstl, secondL, vowels)
      end
    end
  end

  # Places one vowel between two viable letters, returns success
  private
  def oneVowelTwoLetters(firstL, secondL, vowel)
    if (secondL.uptail)
      # First, if secondL is an uptail, place the vowel above secondL
      return placeAbove(secondL, vowel)
    elsif (firstL.uptail)
      # Second, if firstL is an uptail, place the vowel below firstL
      return placeBelow(firstL, vowel)
    else
      # Finally, both must be downtails, place the vowel above secondL
      return placeAbove(secondL, vowel)
    end
  end

  # Places two vowels between two viable letters, returns success
  private
  def twoVowelsTwoLetters(firstL, secondL, vowels)
    vowel1 = vowels[0]
    vowel2 = vowels[1]

    return placeAbove(secondL, vowel2) && placeBelow(firstL, vowel1)
  end

  # Places multiple vowels between two viable letters, adding placeholders, returns success
  private
  def multipleVowelsTwoLetters(firstL, secondL, vowels)
    # Place the first vowel below the available first letter
    success = placeBelow(firstL, vowels[0])
    if (!success)
      return false
    end

    # Add placeholders with vowels attached after the first letter
    prevPlaceholder = nil
    for i in 1..(vowels.length - 2)
      if (!prevPlaceholder || i % 2 == 1)
        # Make a new placeholder
        nextIndex = !prevPlaceholder ? firstL.index + 0.5 : (prevPlaceholder.index + secondL.index) / 2
        prevPlaceholder = Letter.new("sp", true, nextIndex)
        @edigaulLetters[nextIndex] = prevPlaceholder

        success = placeAbove(prevPlaceholder, vowels[i])
        if (!success)
          return false
        end
      else
        success = placeBelow(prevPlaceholder, vowels[i])
        if (!success)
          return false
        end
      end
    end

    # Add the last vowel
    if (prevPlaceholder.vowelAvailable(BOTTOM))
      return oneVowelTwoLetters(prevPlaceholder, secondL, vowels[vowels.length - 1])
    else
      return placeAbove(secondL, vowels[vowels.length - 1])
    end
  end

  # Places one vowel on one viable letter, returns success
  private
  def oneVowelOneLetter(firstL, secondL, vowel)
    if (!firstL)
      return placeAbove(secondL, vowel)
    else
      return placeBelow(firstL, vowel)
    end
  end

  # Places multiple vowels on and next to one viable letter, adding placeholders, returns success
  private
  def multipleVowelsOneLetter(firstL, secondL, vowels)
    if (!firstL)
      # Place the last vowel above the available second letter
      success = placeAbove(secondL, vowels[vowels.length - 1])
      if (!success)
        return false
      end

      # Add placeholders with vowels attached before the second letter
      prevPlaceholder = nil
      for i in 0..(vowels.length - 2)
        if (!prevPlaceholder || i % 2 == 0)
          # Make a new placeholder
          nextIndex = !prevPlaceholder ? secondL.index - 0.5 : (prevPlaceholder.index + secondL.index) / 2
          prevPlaceholder = Letter.new("sp", true, nextIndex)
          @edigaulLetters[nextIndex] = prevPlaceholder

          return placeAbove(prevPlaceholder, vowels[i])
        else
          return placeBelow(prevPlaceholder, vowels[i])
        end
      end
    else
      # Place the first vowel below the available first letter
      success = placeBelow(firstL, vowels[0])
      if (!success)
        return false
      end

      # Add placeholders with vowels attached after the first letter
      prevPlaceholder = nil
      for i in 1..(vowels.length - 1)
        if (!prevPlaceholder || i % 2 == 1)
          # Make a new placeholder
          nextIndex = !prevPlaceholder ? firstL.index - 0.5 : (prevPlaceholder.index + firstL.index + 1) / 2
          prevPlaceholder = Letter.new("sp", true, nextIndex)
          @edigaulLetters[nextIndex] = prevPlaceholder

          return placeAbove(prevPlaceholder, vowels[i])
        else
          return placeBelow(prevPlaceholder, vowels[i])
        end
      end
    end
  end

  # Places multiple vowels between two non-viable letters, adding placeholders, returns success
  private
  def multipleVowelsNoLetters(midIndex, vowels)
    # Add placeholders with vowels attached before the second letter
    prevPlaceholder = nil
    for i in 0..(vowels.length - 1)
      if (!prevPlaceholder || i % 2 == 0)
        # Make a new placeholder
        nextIndex = !prevPlaceholder ? midIndex : (prevPlaceholder.index + midIndex + 0.5) / 2
        prevPlaceholder = Letter.new("sp", true, nextIndex)
        @edigaulLetters[nextIndex] = prevPlaceholder

        return placeAbove(prevPlaceholder, vowels[i])
      else
        return placeBelow(prevPlaceholder, vowels[i])
      end
    end
  end

  # Places a vowel mark above a consonant, returns success
  private
  def placeAbove(l, vowel)
    if (l.vowelAvailable(TOP))
      l.setVowel(vowel, TOP)
      return true
    else
      return false
    end
  end

  # Places a vowel mark below a consonant, returns success
  private
  def placeBelow(l, vowel)
    if (l.vowelAvailable(BOTTOM))
      l.setVowel(vowel, BOTTOM)
      return true
    else
      return false
    end
  end
end