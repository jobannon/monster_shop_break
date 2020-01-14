class Order < ApplicationRecord
  validates_presence_of :name, :address, :city, :state, :zip

  belongs_to :user
  belongs_to :coupon
  has_many :item_orders
  has_many :items, through: :item_orders

  enum status: ['Pending', 'Packaged', 'Shipped', 'Cancelled']

  def grandtotal
    '%.2f' % item_orders.sum('price * quantity')
  end

  def total_quantity
    item_orders.sum('quantity')
  end

  def merchant_grandtotal(merchant)
    '%.2f' % items.where(merchant: merchant).sum("item_orders.price * item_orders.quantity")
  end
  
  def merchant_orders(merchant_id)
    item_orders.joins(:item).where('items.merchant_id = ?', merchant_id)
  end

  def merchant_total_quantity(merchant)
    items.where(merchant: merchant).sum("item_orders.quantity")
  end

  def self.custom_sort
    orders = self.all.joins(:user)
    sort_order = ['Packaged','Pending','Shipped','Cancelled']
    sorted = orders.sort_by do |order|
      sort_order.index(order.status)
    end
  end
end
