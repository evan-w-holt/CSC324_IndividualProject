module ApplicationHelper
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
end
