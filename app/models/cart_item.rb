class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :product

  validates :quantity, numericality: { greater_than_or_equal_to: 0 }

  after_create :update_cart_total_price
  after_update :update_cart_total_price_if_needed
  after_destroy :update_cart_total_price

  def total_price
    quantity * product.price
  end

  private

  def update_cart_total_price
    cart.update(total_price: cart.cart_items.sum(&:total_price))
  end

  def update_cart_total_price_if_needed
    return unless saved_change_to_quantity? || saved_change_to_product_id?
    
    update_cart_total_price
  end
end
