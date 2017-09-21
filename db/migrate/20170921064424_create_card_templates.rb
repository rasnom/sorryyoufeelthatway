class CreateCardTemplates < ActiveRecord::Migration[5.1]
  def change
    create_table :card_templates do |t|
      t.string "greeting"
      t.timestamps
    end
  end
end
