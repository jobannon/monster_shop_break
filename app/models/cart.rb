class Cart
  attr_reader :contents

  def initialize(contents)
    @contents = contents
  end

  def add_item(item)
    @contents[item] = 0 if !@contents[item]
    @contents[item] += 1
  end

  def total_items
    @contents.values.sum
  end

  def items
    item_quantity = {}
    @contents.each do |item_id,quantity|
      item_quantity[Item.find(item_id)] = quantity
    end
    item_quantity
  end

  def subtotal(item)
    item.price * @contents[item.id.to_s]
  end

  def discounted_subtotal(percentage_off)
    #need to move session logic out but for now...
    #why dont we have a cart spec
    total * (100 - percentage_off) / 100
  end

  def total
    @contents.sum do |item_id,quantity|
      Item.find(item_id).price * quantity
    end
  end

  def add_quantity(item_id)
    @contents[item_id] += 1
  end

  def subtract_quantity(item_id)
    @contents[item_id] -= 1
  end

  def limit_reached?(item_id)
    @contents[item_id] == Item.find(item_id).inventory
  end

  def quantity_zero?(item_id)
    @contents[item_id] == 0
  end

  def apply_coupon(coupon)
  end
end
