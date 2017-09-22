class CreateCards < ActiveRecord::Migration[5.1]
  def change
    create_table :cards do |t|
      t.references :card_template
      t.string :custom_message
      t.string :signature
      t.string :recipient_name, not_null: true
      t.string :street_address, not_null: true
      t.string :city, not_null: true
      t.string :state, not_null: true
      t.string :zip_code, not_null: true
      t.timestamp :sent

      t.timestamps
    end
  end
end
