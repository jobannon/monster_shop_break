require "rails_helper"

describe Cart, type: :model do 
  describe "instance_methods" do 
    before(:each) do
      @mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @paper = @mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)
      @pencil = @mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)

      @user = create :random_reg_user_test
       
      @coupon_1 = @meg.coupons.create(name: "10 percent off", coupon_code: "10off", percentage_off: 10)
    end
    it "discounted_subtotal(percentage_off, merchant_id)" do
      @cart = Cart.new({@tire.id => 1})
      expect(@cart.discounted_subtotal(10, @meg.id)).to eq(112)
    end

  end
end
