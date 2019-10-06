class CreateWords < ActiveRecord::Migration[5.1]
  def change
    create_table :words do |t|
      t.string :rohkshe
      t.string :transliteration
      t.string :translation

      t.timestamps
    end
  end
end
