require 'rails_helper'

describe Order, type: :model do
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :address }
    it { should validate_presence_of :city }
    it { should validate_presence_of :state }
    it { should validate_presence_of :zip }
  end

  describe "relationships" do
    it {should have_many :item_orders}
    it {should have_many(:items).through(:item_orders)}
    it {should belong_to :user}
    it {should belong_to(:coupon).optional}
  end

  describe 'instance methods' do
    before :each do
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @brian = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @pull_toy = @brian.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
      @user_1 = create :random_reg_user_test


      @order_1 = Order.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033, user_id: @user_1.id)

      @item_order_1 = @order_1.item_orders.create!(item: @tire, price: @tire.price, quantity: 2)
      @item_order_2 = @order_1.item_orders.create!(item: @pull_toy, price: @pull_toy.price, quantity: 3)
    end
    it 'grandtotal' do
      expect(@order_1.grandtotal).to eq('230.00')
    end

    it 'total_quantity' do
      expect(@order_1.total_quantity).to eq(5)
    end

    it 'merchant_grandtotal' do
      expect(@order_1.merchant_grandtotal(@brian)).to eq('30.00')
    end

    it 'merchant_total_quantity' do
      expect(@order_1.merchant_total_quantity(@brian)).to eq(3)
    end

    it 'merchant_orders' do
      expect(@order_1.merchant_orders(@brian.id)).to eq([@item_order_2])
    end
  end

  describe 'class methods' do
    before :each do
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @brian = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @pull_toy = @brian.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
      @user_1 = create :random_reg_user_test

      @order_1 = Order.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033, user_id: @user_1.id)
      @order_1.item_orders.create!(item: @tire, price: @tire.price, quantity: 2)
      @order_1.item_orders.create!(item: @pull_toy, price: @pull_toy.price, quantity: 3)

      @order_2 = Order.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033, user_id: @user_1.id)
      @order_2.item_orders.create!(item: @tire, price: @tire.price, quantity: 2)
      @order_2.item_orders.create!(item: @pull_toy, price: @pull_toy.price, quantity: 3)

      @order_3 = Order.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033, user_id: @user_1.id)
      @order_3.item_orders.create!(item: @tire, price: @tire.price, quantity: 2)
      @order_3.item_orders.create!(item: @pull_toy, price: @pull_toy.price, quantity: 3)

      @order_4 = Order.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033, user_id: @user_1.id)
      @order_4.item_orders.create!(item: @tire, price: @tire.price, quantity: 2)
      @order_4.item_orders.create!(item: @pull_toy, price: @pull_toy.price, quantity: 3)

      @order_5 = Order.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033, user_id: @user_1.id, status: 1)
      @order_5.item_orders.create!(item: @tire, price: @tire.price, quantity: 2)
      @order_5.item_orders.create!(item: @pull_toy, price: @pull_toy.price, quantity: 3)

      @order_6 = Order.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033, user_id: @user_1.id, status: 1)
      @order_6.item_orders.create!(item: @tire, price: @tire.price, quantity: 2)
      @order_6.item_orders.create!(item: @pull_toy, price: @pull_toy.price, quantity: 3)
    end

    it 'displays orders by custom order status: Packaged then Pending then Shipped then Cancelled' do
      @order_1.update(status: 3) # change status to cancelled
      @order_2.update(status: 2) # change status to shipped
      @order_3.update(status: 0) # change status to pending
      @order_4.update(status: 1) # change status to packaged
      expect(Order.custom_sort).to eq([@order_5, @order_6, @order_4, @order_3, @order_2, @order_1])
    end
  end
end
