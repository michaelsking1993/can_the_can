class AddTempPosToBaseWords < ActiveRecord::Migration[5.0]
  def change
    add_column :base_words, :temp_pos, :string
  end
end
