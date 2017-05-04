class AddPosTagToInflections < ActiveRecord::Migration[5.0]
  def change
    add_column :inflections, :pos_tag, :string
  end
end
