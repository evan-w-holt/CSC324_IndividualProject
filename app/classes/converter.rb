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
    @english_letters = @input.split(",").reject(&:empty?)
    @english_vowels = {}
    @edigaul_letters = {}

    @english_letters.each_with_index do |l, i|
      if (!VOWELS.include?(l))
        is_uptail = UPTAILS.include?(l)

        # Ensure letter is valid
        if (!is_uptail && !DOWNTAILS.include?(l) && l != MORPHEME_BREAK)
          @error = "Invalid character #{l}"
          return
        end

        letter = Letter.new(l, is_uptail, i.to_f)
        @edigaul_letters[i.to_f] = letter
      else
        @english_vowels[i.to_f] = l
      end
    end

    edigaul_keys = @edigaul_letters.keys.sort
    prev_l = nil

    # Add the beginning and middle vowel marks
    edigaul_keys.each do |i|
      this_l = @edigaul_letters[i]

      starting = (prev_l ? prev_l.index + 1 : 0).floor
      ending = this_l.index.floor
      vowels = get_vowels(starting, ending)

      first_l  = (!prev_l || prev_l.is_morpheme_break || prev_l.is_x) ? nil : prev_l
      second_l = (!this_l || this_l.is_morpheme_break || this_l.is_x) ? nil : this_l

      if (vowels.length > 0)
        success = assign_vowels(first_l, second_l, vowels, (starting.to_f + ending) / 2)

        if (!success)
          @error = "Error assigning vowel marks between consonants #{prev_l.consonant} and #{this_l.consonant}"
          return
        end
      end

      prev_l = this_l
    end

    # Add the remaining vowel marks
    starting = (prev_l ? prev_l.index + 1 : 0).floor
    ending = -1
    vowels = get_vowels(starting, ending)

    first_l = (!prev_l || prev_l.is_morpheme_break || prev_l.is_x) ? nil : prev_l

    if (vowels.length > 0)
      success = assign_vowels(first_l, nil, vowels, starting.to_f + 1)

      if (!success)
        @error = "Error assigning vowel marks after consonant #{prev_l.consonant}"
        return
      end
    end
  end

  # Gets the Edigaul that this converter object has generated from its input
  def get_edigaul
    if (@error)
      return @error
    else
      edigaul = ""

      edigaul_keys = @edigaul_letters.keys.sort
      edigaul_keys.each do |i|
        edigaul += @edigaul_letters[i].get_full_letter
      end

      return edigaul
    end
  end

  private
    # Gets the vowels to be placed between two letters
    def get_vowels(starting, ending)
      vowels = []

      if (ending != -1)
        for i in starting...ending
          v = @english_vowels[i.to_f]
          
          if (v)
            vowels << v
            @english_vowels.delete(i.to_f)
          end
        end
      else
        # Get all remaining vowels
        i = starting

        while (@english_vowels.keys.length > 0)
          v = @english_vowels[i.to_f]

          if (v)
            vowels << v
            @english_vowels.delete(i.to_f)
          end

          i += 1
        end
      end

      return vowels
    end

    # Assigns vowels, returns whether or not the operation was successful
    def assign_vowels(first_l, second_l, vowels, mid_index)
      # Check vowel validity
      vowels.each do |vowel|
        if (!VOWELS.include?(vowel))
          return false
        end
      end

      if (first_l && second_l)
        # Both letters can take vowel marks
        if (vowels.length == 1)
          return one_vowel_two_letters(first_l, second_l, vowels[0])
        elsif (vowels.length == 2)
          return two_vowels_two_letters(first_l, second_l, vowels)
        else
          return multiple_vowels_two_letters(first_l, second_l, vowels)
        end
      elsif (!first_l && !second_l)
        # Neither letter can take vowel marks, add placeholders (sp)
        return multiple_vowels_no_letters(mid_index, vowels)
      else
        # Only one letter can take vowel marks
        if (vowels.length == 1)
          return one_vowel_one_letter(first_l, second_l, vowels[0])
        else
          return multiple_vowels_one_letter(first_l, second_l, vowels)
        end
      end
    end

    # Places one vowel between two viable letters, returns success
    def one_vowel_two_letters(first_l, second_l, vowel)
      if (second_l.uptail)
        # First, if second_l is an uptail, place the vowel above second_l
        return place_above(second_l, vowel)
      elsif (first_l.uptail)
        # Second, if first_l is an uptail, place the vowel below first_l
        return place_below(first_l, vowel)
      else
        # Finally, both must be downtails, place the vowel above second_l
        return place_above(second_l, vowel)
      end
    end

    # Places two vowels between two viable letters, returns success
    def two_vowels_two_letters(first_l, second_l, vowels)
      vowel1 = vowels[0]
      vowel2 = vowels[1]

      return place_above(second_l, vowel2) && place_below(first_l, vowel1)
    end

    # Places multiple vowels between two viable letters, adding placeholders, returns success
    def multiple_vowels_two_letters(first_l, second_l, vowels)
      # Place the first vowel below the available first letter
      success = place_below(first_l, vowels[0])
      if (!success)
        return false
      end

      # Add placeholders with vowels attached after the first letter
      prev_placeholder = nil
      for i in 1...(vowels.length - 1)
        if (!prev_placeholder || i % 2 == 1)
          # Make a new placeholder
          next_index = !prev_placeholder ? first_l.index + 0.5 : (prev_placeholder.index + second_l.index) / 2
          prev_placeholder = Letter.new("sp", true, next_index)
          @edigaul_letters[next_index] = prev_placeholder

          success = place_above(prev_placeholder, vowels[i])
          if (!success)
            return false
          end
        else
          success = place_below(prev_placeholder, vowels[i])
          if (!success)
            return false
          end
        end
      end

      # Add the last vowel
      if (prev_placeholder.vowel_available(BOTTOM))
        return one_vowel_two_letters(prev_placeholder, second_l, vowels[-1])
      else
        return place_above(second_l, vowels[-1])
      end
    end

    # Places one vowel on one viable letter, returns success
    def one_vowel_one_letter(first_l, second_l, vowel)
      if (!first_l)
        return place_above(second_l, vowel)
      else
        return place_below(first_l, vowel)
      end
    end

    # Places multiple vowels on and next to one viable letter, adding placeholders, returns success
    def multiple_vowels_one_letter(first_l, second_l, vowels)
      if (!first_l)
        # Place the last vowel above the available second letter
        success = place_above(second_l, vowels[-1])
        if (!success)
          return false
        end

        # Add placeholders with vowels attached before the second letter
        prev_placeholder = nil
        for i in 0...(vowels.length - 1)
          if (!prev_placeholder || i % 2 == 0)
            # Make a new placeholder
            next_index = !prev_placeholder ? second_l.index - 0.5 : (prev_placeholder.index + second_l.index) / 2
            prev_placeholder = Letter.new("sp", true, next_index)
            @edigaul_letters[next_index] = prev_placeholder

            return place_above(prev_placeholder, vowels[i])
          else
            return place_below(prev_placeholder, vowels[i])
          end
        end
      else
        # Place the first vowel below the available first letter
        success = place_below(first_l, vowels[0])
        if (!success)
          return false
        end

        # Add placeholders with vowels attached after the first letter
        prev_placeholder = nil
        for i in 1...vowels.length
          if (!prev_placeholder || i % 2 == 1)
            # Make a new placeholder
            next_index = !prev_placeholder ? first_l.index - 0.5 : (prev_placeholder.index + first_l.index + 1) / 2
            prev_placeholder = Letter.new("sp", true, next_index)
            @edigaul_letters[next_index] = prev_placeholder

            return place_above(prev_placeholder, vowels[i])
          else
            return place_below(prev_placeholder, vowels[i])
          end
        end
      end
    end

    # Places multiple vowels between two non-viable letters, adding placeholders, returns success
    def multiple_vowels_no_letters(mid_index, vowels)
      # Add placeholders with vowels attached before the second letter
      prev_placeholder = nil
      for i in 0...vowels.length
        if (!prev_placeholder || i % 2 == 0)
          # Make a new placeholder
          next_index = !prev_placeholder ? mid_index : (prev_placeholder.index + mid_index + 0.5) / 2
          prev_placeholder = Letter.new("sp", true, next_index)
          @edigaul_letters[next_index] = prev_placeholder

          return place_above(prev_placeholder, vowels[i])
        else
          return place_below(prev_placeholder, vowels[i])
        end
      end
    end

    # Places a vowel mark above a consonant, returns success
    def place_above(l, vowel)
      if (l.vowel_available(TOP))
        l.set_vowel(vowel, TOP)
        return true
      else
        return false
      end
    end

    # Places a vowel mark below a consonant, returns success
    def place_below(l, vowel)
      if (l.vowel_available(BOTTOM))
        l.set_vowel(vowel, BOTTOM)
        return true
      else
        return false
      end
    end
end