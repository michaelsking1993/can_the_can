class RemoveWordFormFromInflections < ActiveRecord::Migration[5.0]
  def change
    remove_column :inflections, :word_form, :integer
  end
end
