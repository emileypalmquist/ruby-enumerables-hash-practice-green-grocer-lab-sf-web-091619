require 'pry'

def consolidate_cart(cart)
  result = {}
  
  cart.each do |element_hash|
    element_name = element_hash.keys[0]
    
    if result.has_key?(element_name)
      result[element_name][:count] += 1
    else
      result[element_name] = {
        count: 1,
        price: element_hash[element_name][:price],
        clearance: element_hash[element_name][:clearance]
      }
    end
  end
  
  result
end

def apply_coupons(cart, coupon)
  coupons.each do |coupon|
    item = coupon[:item]
    if cart[item]
      if cart[item][:count] >= coupon[:num] && !cart.has_key?("#{item} W/COUPON")         
        cart["#{item} W/COUPON"] = {price: coupon[:cost] / coupon[:num], clearance: cart[item][:clearance], count: coupon[:num]}
        cart[item][:count] -= coupon[:num]
      elsif cart[item][:count] >= coupon[:num] && cart.has_key?("#{item} W/COUPON")
        cart["#{item} W/COUPON"] += coupon[:num]
        cart[item][:count] -= coupon[:num]
      end
    end
  end
  cart
end


def apply_clearance(cart)
  clearance_cart = {}
  
  cart.each do |food, info|
    clearance_cart[food] = {}
    if info[:clearance] == true
      clearance_cart[food][:price] = info[:price] * 4 / 5
    else
      clearance_cart[food][:price] = info[:price]
    end
    clearance_cart[food][:clearance] = info[:clearance]
    clearance_cart[food][:count] = info[:count]
  end
  clearance_cart

end

def checkout(cart, coupons)
  total = 0 
  new_cart = consolidate_cart(cart) 
  coupon_cart = apply_coupons(new_cart, coupons) 
  clearance_cart = apply_clearance(coupon_cart) 
  
  clearance_cart.each do |item, attribute| 
    total += (attribute[:price] * attribute[:count])
  end 
  
  total > 100 ? total * 0.9 : total 
  
end
