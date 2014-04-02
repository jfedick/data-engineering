class Merchant < ActiveRecord::Base
  has_many :items
  has_many :purchases
  has_many :purchasers, through: :purchases
end
