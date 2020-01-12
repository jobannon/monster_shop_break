class CreateCoupons < ActiveRecord::Migration[5.1]
  def change
    create_table :coupons do |t|
      t.string :name
      t.string :coupon_code
      t.float :percentage_off
      t.belongs_to :merchant, foreign_key: true
    end
  end
end
