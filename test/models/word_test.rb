require 'test_helper'

class WordTest < ActiveSupport::TestCase
  def setup
    @valid_word = Word.new(
      rohkshe: "[+k+uh][+th+][+n+ee]",
      transliteration: "kuthni",
      translation: "river"
    )

    @no_rohkshe = Word.new(
      rohkshe: "     ",
      transliteration: "kuthni",
      translation: "river"
    )

    @no_transliteration = Word.new(
      rohkshe: "[+k+uh][+th+][+n+ee]",
      transliteration: "     ",
      translation: "river"
    )

    @no_translation = Word.new(
      rohkshe: "[+k+uh][+th+][+n+ee]",
      transliteration: "kuthni",
      translation: "     "
    )

    @invalid_rohkshe = Word.new(
      rohkshe: "[+k+uh]in[+th+]val[+n+ee]id",
      transliteration: "kuthni",
      translation: "river"
    )
  end

  # Validation tests ==================================================

  test "valid word should be valid" do
    assert @valid_word.valid?
  end

  test "missing rohkshe should be invalid" do
    assert_not @no_rohkshe.valid?
  end

  test "missing transliteration should be invalid" do
    assert_not @no_transliteration.valid?
  end

  test "missing translation should be invalid" do
    assert_not @no_translation.valid?
  end

  test "rohkshe that does not follow regex should be invalid" do
    assert_not @invalid_rohkshe.valid?
  end
end
