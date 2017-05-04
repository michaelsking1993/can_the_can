class CreateBaseWords < ActiveRecord::Migration[5.0]
  def change
    create_table :base_words do |t|
      t.string :base_word
      t.references :pos, foreign_key: true
      t.integer :frequency
      t.references :language, foreign_key: true

      t.timestamps
    end
  end
end
