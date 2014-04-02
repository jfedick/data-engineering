class CreatePurchases < ActiveRecord::Migration
  def change
    create_table :purchases do |t|
      t.integer :purchase_datum_id
      t.integer :purchaser_id
      t.integer :item_id
      t.integer :merchant_id
      t.integer :purchase_count

      t.timestamps
    end
  end
end
