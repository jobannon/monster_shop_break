require 'rails_helper'

RSpec.describe "as a merchant user" do 
  describe "when I visit the the merchant coupons show page" do 
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

    it "shows me a button to delete the coupon" do 
      visit merchant_coupon_path(@coupon_1)

      within "#coupon_individual-#{@coupon_1.id}" do 
        click_button "Delete Coupon"
      end

      expect(page).to have_content('This coupon was sucessfully be deleted')
      expect(page).not_to have_content(@coupon_1.name)
      expect(page).to have_content(@coupon_2.name)
    end 

    it "will not let me delete the coupon if its already on an order" do 
      visit merchant_coupon_path(@coupon_1)

      mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
      paper = mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 25)
      pencil = mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)

      user = User.create!(name: "jess", address: "jess way", city: "denver", state: "co", zip: 80023, role: 0, email: "jess@j.com", password: "password")
      user.orders.create!(name: "bob", address: "1 way", city: "denver", state: "md", zip: 22235, coupon_id: @coupon_1.id )
      holder = user.orders[0].item_orders.create!({item: paper, quantity: 1, price: 10 })
      
      within "#coupon_individual-#{@coupon_1.id}" do 
        click_button "Delete Coupon"
      end

      expect(page).to have_content('This coupon cannot be deleted')
      expect(page).to have_content(@coupon_1.name)
      expect(page).to have_content(@coupon_2.name)
    end 
  end
end 
