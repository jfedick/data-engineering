class Item < ActiveRecord::Base
  has_many :purchases
  belongs_to :merchant
end
