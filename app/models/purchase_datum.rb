class PurchaseDatum < ActiveRecord::Base
  mount_uploader :file, FileUploader
  has_many :purchases

  def process_file!
    file = self.file.file.to_file
    file.lines.each_with_index do |line, index|
      next if index == 0
      parse! line
    end
  end

  def parse! line
    purchase_details_array = line.strip.split(/\t/)     
    purchaser = Purchaser.find_or_create_by!(name: purchase_details_array[0])
    item = Item.find_or_create_by!(description: purchase_details_array[1], price: purchase_details_array[2])
    merchant = Merchant.find_or_create_by!(address: purchase_details_array[4], name: purchase_details_array[5])
    Purchase.create!(
      purchase_datum: self,
      purchaser: purchaser,
      item: item,
      merchant: merchant,
      purchase_count: purchase_details_array[3]
    )
  end

  def gross_revenue
    sum = 0
    purchases = Purchase.where(purchase_datum_id: self.id)
    purchases.each do |purchase|
      sum += (purchase.item.price * purchase.purchase_count)
    end
    sum
  end
end