class AddPosTagToBaseWords < ActiveRecord::Migration[5.0]
  def change
    add_column :base_words, :pos_tag, :string
  end
end
