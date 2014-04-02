class CreatePurchaseData < ActiveRecord::Migration
  def change
    create_table :purchase_data do |t|
      t.string :file

      t.timestamps
    end
  end
end
