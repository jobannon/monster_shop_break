class Coupon < ApplicationRecord
  belongs_to :merchant
  has_many :orders
  validates_presence_of :percentage_off, :name, :coupon_code 
  validates_uniqueness_of :name, :coupon_code
  validates_numericality_of :percentage_off, less_than: 100 
  validates_numericality_of :percentage_off, greater_than: 0 

end
