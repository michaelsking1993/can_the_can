class CreateSongLineWords < ActiveRecord::Migration[5.0]
  def change
    create_table :song_line_words do |t|
      t.string :song_word
      t.references :inflection, foreign_key: true
      t.references :song_line, foreign_key: true

      t.timestamps
    end
  end
end
