def consolidate_cart(cart)
  cart_hash = {}

  cart.each do |list|
    list.each do |item, attributes|
      if cart_hash.include?(item)
        cart_hash[item][:count] += 1
      else
        cart_hash[item] = attributes
        cart_hash[item][:count] = 1
      end
    end
  end
  cart_hash
end

def apply_coupons(cart, coupons)
  coupon_cart = {}
  coupons.each do |coupon|
    cart.each do |item, attributes|
      if coupon[:item] == item && coupon[:num] <= attributes[:count] && coupon_cart["#{item} W/COUPON"] == nil
        coupon_cart["#{item} W/COUPON"] =
        {
          price: coupon[:cost],
          clearance: attributes[:clearance],
          count: 1
        }
        attributes[:count] -= coupon[:num]
      elsif coupon[:item] == item && coupon[:num] <= attributes[:count] && coupon_cart["#{item} W/COUPON"] != nil
        coupon_cart["#{item} W/COUPON"][:count] += 1
        attributes[:count] -= coupon[:num]
      end
    end
  end
  cart.merge(coupon_cart)
end

def apply_clearance(cart)
  cart.each do |item, attributes|
      if attributes[:clearance] == true
        attributes[:price] -= attributes[:price]*0.2
      end
  end
  cart
end

def checkout(cart, coupons)
  consolidated = consolidate_cart(cart)
  couponed = apply_coupons(consolidated, coupons)
  clearance = apply_clearance(couponed)

  total = 0
  
  clearance.each do |item, attributes|
    total += attributes[:price] * attributes[:count]
  end

  if total > 100
    total -= total * 0.1
  end
  total
end
