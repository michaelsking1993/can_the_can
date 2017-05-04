class RemovePosReferencesFromBaseWords < ActiveRecord::Migration[5.0]
  def change
    remove_reference :base_words, :pos, foreign_key: false
  end
end
