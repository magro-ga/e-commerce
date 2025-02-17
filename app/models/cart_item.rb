class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :product

  validates :quantity, numericality: { greater_than_or_equal_to: 0 }

  before_save :set_unit_price

  def total_price
    quantity * product.price
  end

  private

  def set_unit_price
    self.unit_price = product.price if unit_price.nil? || unit_price.zero?
  end
end
