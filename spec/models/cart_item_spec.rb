require "rails_helper"

RSpec.describe CartItem, type: :model do
  describe "associations" do
    it { should belong_to(:cart) }
  end

  describe "validations" do
    it { should validate_numericality_of(:quantity).only_integer.is_greater_than(0) }
    it { should validate_numericality_of(:unit_price).is_greater_than_or_equal_to(0) }
  end

  describe "#total_price" do
    it "calcula corretamente o preço total do item" do
      cart_item = CartItem.new(quantity: 3, unit_price: 10.50)
      expect(cart_item.total_price).to eq(31.50)
    end
  end
end
