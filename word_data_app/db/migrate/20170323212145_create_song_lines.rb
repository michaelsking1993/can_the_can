class CreateSongLines < ActiveRecord::Migration[5.0]
  def change
    create_table :song_lines do |t|
      t.references :song, foreign_key: true
      t.integer :line_number

      t.timestamps
    end
  end
end
