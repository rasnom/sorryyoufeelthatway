class AddImageFileToCardTemplate < ActiveRecord::Migration[5.1]
  def change
    add_column :card_templates, :image_file, :string, null: false
    change_column_null :card_templates, :greeting, false
  end
end
