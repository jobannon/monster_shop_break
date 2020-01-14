require 'rails_helper'

RSpec.describe "as a merchant user" do 
  describe "when I visit the the merchant coupons show page" do 
    before(:each) do 
      @target = Merchant.create!(name: "target coup", address: "100 some drive", city: "denver", state: "co", zip: 80023)
      @merchant_user = @target.users.create!(name: "show merch", address: "show", city: "denver", state: "co", zip: 80023, role: 2, email: "joe3@ge.com", password: "password")

      @coupon_1 = @target.coupons.create!(name: "Summer Saver", coupon_code: "sum-save", percentage_off: 10)
      @coupon_2 = { name: "Winter Saver", coupon_code: "winter-save", percentage_off: 50  }
      #log in as a merch
      visit login_path

      fill_in :email, with: @merchant_user.email 
      fill_in :password, with: "password"

      click_button 'Log In'
    end 
    it "allows me to edit a coupon" do 

      visit edit_merchant_coupon_path(@coupon_1)

      fill_in :name, with: @coupon_2[:name] 
      fill_in :coupon_code, with: @coupon_2[ :coupon_code ]
      fill_in :percentage_off, with: @coupon_2[ :percentage_off ]

      click_button "Update Coupon"

      expect(current_path).to eq(merchant_coupons_path)
      last_coupon = Coupon.last
      expect(last_coupon.name).to eq(@coupon_2[ :name ]) 
      expect(last_coupon.coupon_code).to eq(@coupon_2[ :coupon_code ]) 
      expect(last_coupon.percentage_off).to eq(@coupon_2[ :percentage_off ]) 
    end
  end
end

