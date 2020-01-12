class Coupon < ApplicationRecord
  belongs_to :merchant
  validates_presence_of :percentage_off, :name, :coupon_code 
  validates_numericality_of :percentage_off, less_than: 100 
end
