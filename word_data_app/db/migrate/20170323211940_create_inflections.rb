class CreateInflections < ActiveRecord::Migration[5.0]
  def change
    create_table :inflections do |t|
      t.references :base_word, foreign_key: true
      t.string :word

      t.timestamps
    end
  end
end
