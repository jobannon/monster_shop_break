require 'rails_helper'

RSpec.describe 'Cart show' do
  describe 'When I have added items to my cart' do
    describe 'and visit my cart path' do
      before(:each) do
        @mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
        @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
        @coupon_1 = @meg.coupons.create(name: "10 percent off", coupon_code: "10off", percentage_off: 10)

        @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
        @paper = @mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 25)
        @coffee = @mike.items.create(name: "The Best Cup o' Jo!", description: "Keeps you awake for days!", price: 20, image: "https://cdn.caskers.com/catalog/product/cache/207e23213cf636ccdef205098cf3c8a3/d/e/death-wish_01.jpg", inventory: 2)
        @pencil = @mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)
        visit "/items/#{@paper.id}"
        click_on "Add To Cart"
        visit "/items/#{@tire.id}"
        click_on "Add To Cart"
        visit "/items/#{@pencil.id}"
        click_on "Add To Cart"
        @items_in_cart = [@paper,@tire,@pencil]
      end

      it 'I can empty my cart by clicking a link' do
        visit '/cart'
        expect(page).to have_link("Empty Cart")
        click_on "Empty Cart"
        expect(current_path).to eq("/cart")
        expect(page).to_not have_css(".cart-items")
        expect(page).to have_content("Cart is currently empty")
      end

      it 'I see all items Ive added to my cart' do
        visit '/cart'

        @items_in_cart.each do |item|
          within "#cart-item-#{item.id}" do
            expect(page).to have_link(item.name)
            expect(page).to have_css("img[src*='#{item.image}']")
            expect(page).to have_link("#{item.merchant.name}")
            expect(page).to have_content("$#{item.price}")
            expect(page).to have_content("1")
            expect(page).to have_content("$#{item.price}")
          end
        end
        expect(page).to have_content("Total: $122")

        visit "/items/#{@pencil.id}"
        click_on "Add To Cart"

        visit '/cart'

        within "#cart-item-#{@pencil.id}" do
          expect(page).to have_content("2")
          expect(page).to have_content("$4")
        end

        expect(page).to have_content("Total: $124")
      end

      it "Shows a button next to each item to increment the count of that item by 1,
          max quantity is the inventory quantity" do

        visit "/items/#{@coffee.id}"
        click_on "Add To Cart"

        visit '/cart'

        within "#add-count-#{@coffee.id}" do 
          expect(page).to have_content("1")
          click_button "+"
          expect(page).to have_content("2")
          click_button "+"
          expect(page).to have_content("2")
        end
      end

      it "Shows a button next to each item to decrement the count of that item by 1,
          min quantity is 0, and the item is immediately removed from the cart" do

        visit "/items/#{@coffee.id}"
        click_on "Add To Cart"

        visit '/cart'

        within "#cart-item-#{@coffee.id}" do
          expect(page).to have_content("1")
          click_button "-"
        end

        expect(page).to_not have_content(@coffee.name)

      end
      it "shows me the input box for adding a coupon code 
         and when I click on that button it:
         -shows an updated cart with a new discounted subtotal field" do 
        visit cart_path
         
        expect(page).to have_button("Apply Coupon Code")

        fill_in :coupon_code, with: @coupon_1.coupon_code

        within "#coupon-application" do 
          click_button "Apply Coupon Code"
        end
        expect(current_path).to eq(cart_path)

        within "#discounted_subtotal" do
          expect(page).to have_content("SubTotal(reflecting coupon): $112")
        end
      end

      it "doesn't allow me to apply a non-existant coupon code" do 
        visit cart_path
         
        expect(page).to have_button("Apply Coupon Code")

        fill_in :coupon_code, with: "dummy" 

        within "#coupon-application" do 
          click_button "Apply Coupon Code"
        end

        expect(current_path).to eq(cart_path)
        expect(page).to have_content("Please Enter A Valid Coupon")
      end
    end 
  end
end

  describe "When I haven't added anything to my cart" do
    describe "and visit my cart show page" do
      it "I see a message saying my cart is empty" do
        visit '/cart'
        expect(page).to_not have_css(".cart-items")
        expect(page).to have_content("Cart is currently empty")
      end

      it "I do NOT see the link to empty my cart" do
        visit '/cart'
        expect(page).to_not have_link("Empty Cart")
      end
    end
  end
