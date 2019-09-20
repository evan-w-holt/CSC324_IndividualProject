class StaticPagesController < ApplicationController

  # At some point I'll figure out a better way to store these
  # so I can have a lot of words at my disposal

  # TODO: Make these into images
  ALL_ROHKSHE = {
    :water => ["[ithni]", "ithni"],
    :river => ["[kuthni]", "kuthni"],
    :ocean => ["[muuthni]", "muuthni"],
    :'to have' => ["[helai]", "helai"],
    :'to be' => ["[ekai]", "ekai"],
    :hello => ["[oyseh]", "oyseh"],
    :goodbye => ["[vastin]", "vastin"],
    :I => ["[zai]", "zai"],
    :you => ["[zo]", "zo"],
    :one => ["[sikla]", "sikla"],
    :two => ["[pulta]", "pulta"],
    :three => ["[treena]", "treena"]
  }
  ALL_WORDS = [
    :water, :river, :ocean,
    :'to have', :'to be',
    :hello, :goodbye,
    :I, :you,
    :one, :two, :three
  ]

  def home
    @translation = ALL_WORDS.sample

    random_word = ALL_ROHKSHE[@translation]
    @rohkshe = random_word[0]
    @transliteration = random_word[1]
    @translation = @translation.to_s
  end

  def about
  end

  def help
  end
end
