module PriceCalculable
  extend ActiveSupport::Concern

  def total_price
    if respond_to?(:cart_items) # Se for um Cart
      cart_items.sum("quantity * unit_price") || 0
    else # Se for um CartItem
      quantity * unit_price
    end
  end
end
