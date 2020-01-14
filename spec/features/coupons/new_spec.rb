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

    it "allows me to create a coupon" do 
      visit merchant_dashboard_path

      click_link "Coupons"
      expect(current_path).to eq(merchant_coupons_path)

      within "#coupon_actions" do 
        click_button "Create A New Coupon"
      end
      expect(current_path).to eq(new_merchant_coupon_path)

      fill_in :name, with: @coupon_1[:name]
      fill_in :coupon_code, with: @coupon_1[:coupon_code]
      fill_in :percentage_off, with: @coupon_1[:percentage_off]

      click_button "Create Coupon"

      coupon = Coupon.last
      expect(coupon.name).to eq(@coupon_1[:name])
      expect(coupon.coupon_code).to eq(@coupon_1[:coupon_code])
      expect(coupon.percentage_off).to eq(@coupon_1[:percentage_off])
    end
  end
end
