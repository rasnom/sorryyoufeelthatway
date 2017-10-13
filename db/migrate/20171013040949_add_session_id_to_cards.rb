class AddSessionIdToCards < ActiveRecord::Migration[5.1]
  def change
    add_column :cards, :session_id, :string, default: nil
  end
end
