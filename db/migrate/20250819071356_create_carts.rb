class CreateCarts < ActiveRecord::Migration[7.1]
  def change
    create_table :carts do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :status, null: false, default: 0  # 0: active, 1: checked_out
      t.timestamps
    end
    add_index :carts, [:user_id, :status]
  end
end