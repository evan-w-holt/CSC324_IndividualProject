# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

ROHKSHE = {
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

ROHKSHE.each do |key, val|
  Word.create(rohkshe: val[1], transliteration: val[0], translation: key.to_s)
end
