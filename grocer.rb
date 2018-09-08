require 'pry'
def consolidate_cart(cart)
  # code here
  cart_hash = {}

  cart.uniq.each do |item_hash|
    item_hash.each do |item, info_hash|
      cart_hash[item] = info_hash
      cart_hash[item][:count] = cart.count(item_hash)
    end
  end

  cart_hash
end

def apply_coupons(cart, coupons)
  # code here
  coupons.each do |coupon_hash|
    item_name = coupon_hash[:item]

    if cart.has_key?(item_name) && coupon_hash[:num] <= cart[item_name][:count]

      if cart.has_key?("#{item_name} W/COUPON")
        cart["#{item_name} W/COUPON"][:count] = cart["#{item_name} W/COUPON"][:count] + 1
      else
        cart["#{item_name} W/COUPON"] = {
          :price => coupon_hash[:cost],
          :clearance => cart[item_name][:clearance],
          :count => 1
        }
      end

      cart[item_name][:count] -= coupon_hash[:num]
    end

  end

  cart
end

def apply_clearance(cart)
  # code here
  cart.each do |item, info_hash|
    if info_hash[:clearance]
      clearance_price = (info_hash[:price]*0.80).round(1)
      info_hash[:price] = clearance_price
    end
  end

  cart
end

def checkout(cart, coupons)
  # code here
  consolidated_cart = consolidate_cart(cart)

  couponed_cart = apply_coupons(consolidated_cart, coupons)

  clearanced_cart = apply_clearance(couponed_cart)

  total = 0
  clearanced_cart.each do |item, info_hash|
    total += info_hash[:price] * info_hash[:count]
  end

  if total > 100
    total *= 0.9
  end

  total
end