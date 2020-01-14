require 'rails_helper'

RSpec.describe "as a merchant user" do 
  describe "when I visit the the merchant coupons index" do 
    before(:each) do 
      @target = Merchant.create!(name: "target coup", address: "100 some drive", city: "denver", state: "co", zip: 80023)
      @merchant_user = @target.users.create!(name: "show merch", address: "show", city: "denver", state: "co", zip: 80023, role: 2, email: "joe3@ge.com", password: "password")

      @coupon_1 = @target.coupons.create!(name: "Summer Saver", coupon_code: "sum-save", percentage_off: 10)
      @coupon_2 = @target.coupons.create!(name: "Winter Saver", coupon_code: "winter-save", percentage_off: 50) 
      #log in as a merch
      visit login_path

      fill_in :email, with: @merchant_user.email 
      fill_in :password, with: "password"

      click_button 'Log In'
    end 

    it "it shows me 
        -the coupon name 
        -the coupon code
        -the coupon's percentage off for this mechant" do
      
      visit merchant_dashboard_path

      click_link "Coupons" 

      within "#coupon-#{@coupon_1.id}" do 
        expect(page).to have_content(@coupon_1.name)
        expect(page).to have_content(@coupon_1.coupon_code)
        expect(page).to have_content(@coupon_1.percentage_off)
      end

      within "#coupon-#{@coupon_2.id}" do 
        expect(page).to have_content(@coupon_2.name)
        expect(page).to have_content(@coupon_2.coupon_code)
        expect(page).to have_content(@coupon_2.percentage_off)
      end
    end

    it "also allows the coupon name to be a link to the coupon show page" do 
      visit merchant_dashboard_path

      click_link "Coupons" 

      within "#coupon-#{@coupon_1.id}" do 
        click_link @coupon_1.name
        expect(current_path).to eq(merchant_coupon_path(@coupon_1)) 
      end
    end
  end
end

  
