require 'rails_helper'

RSpec.describe "as a merchant user" do 
  describe "when I visit the the merchant coupons show page" do 
    before(:each) do 
      @target = Merchant.create!(name: "target", address: "100 some drive", city: "denver", state: "co", zip: 80023)
      @coupon_1 = Coupon.create!(name: "Summer Saver", coupon_code: "sum-save", percentage_off: 10, merchant_id: @target.id)
      @merchant_user = User.create!(name: "show merch", address: "show", city: "denver", state: "co", zip: 80023, role: 2, email: "joe3@ge.com", password: "password")

      @target.users << @merchant_user 
      
      #log in as a merch
      visit login_path

      fill_in :email, with: @merchant_user.email 
      fill_in :password, with: "password"

      click_button 'Log In'
    end 

    it "shows me the coupon and its attributes" do 
      visit merchant_coupon_path(@coupon_1)

      within "#coupon_individual-#{@coupon_1.id}" do 
        expect(page).to have_content(@coupon_1.name)
        expect(page).to have_content(@coupon_1.percentage_off)
        expect(page).to have_content(@coupon_1.coupon_code)
      end 
    end
  end
end