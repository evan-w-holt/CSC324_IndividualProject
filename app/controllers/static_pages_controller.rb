class StaticPagesController < ApplicationController

  # At some point I'll figure out a better way to store these so I can have a lot of words at my disposal
  ALL_ROHKSHE = {
    :Edigaul => ["Edigaul", [["eh", "D", nil], ["ih", "G", nil], ["aw", "L", nil]]],
    :Rohkshe => ["Rohkshe", [[nil, "R", nil], ["aw", "K", nil], [nil, "Sh", "ee"]]],
    :water => ["ithni", [["ih", "Th", nil], [nil, "N", "ee"]]],
    :river => ["kuthni", [[nil, "K", "uh"], [nil, "Th", nil], [nil, "N", "ee"]]],
    :ocean => ["muuthni", [[nil, "M", "uuh"], [nil, "Th", nil], [nil, "N", "ee"]]],
    :'to have' => ["helai", [[nil, "H", nil], ["eh", "L", "ie"]]],
    :'to be' => ["ekai", [["eh", "K", "ie"]]],
    :hello => ["oyseh", [["oh", "Y", nil], [nil, "S", "eh"]]],
    :goodbye => ["vastin", [[nil, "V", nil], ["ah", "S", nil], [nil, "T", nil], ["ih", "N", nil]]],
    :I => ["zai", [[nil, "Z", "ie"]]],
    :you => ["zo", [[nil, "Z", "oh"]]],
    :one => ["sikla", [[nil, "S", nil], ["ih", "K", nil], [nil, "L", "uh"]]],
    :two => ["pulta", [[nil, "P", nil], ["oo", "L", nil], [nil, "T", "uh"]]],
    :three => ["treena", [[nil, "T", nil], [nil, "R", "ee"], [nil, "N", "uh"]]],
    :this => ["kish", [[nil, "K", nil], ["ih", "Sh", nil]]],
    :that => ["kahsh", [[nil, "K", nil], ["ah", "Sh", nil]]],
    :and => ["oh", [["oh", "SP", nil]]]
  }

  def home
    @translation = ALL_ROHKSHE.keys.sample

    random_word = ALL_ROHKSHE[@translation]
    @transliteration = random_word[0]
    @rohkshe = random_word[1]
    @translation = @translation.to_s
  end

  def about
  end

  def help
  end
end
