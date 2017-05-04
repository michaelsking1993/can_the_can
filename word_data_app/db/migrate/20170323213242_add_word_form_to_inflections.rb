class AddWordFormToInflections < ActiveRecord::Migration[5.0]
  def change
    add_column :inflections, :word_form, :integer
  end
end
