# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CartItem, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:cart) }
    it { is_expected.to belong_to(:product) }
  end

  describe "validations" do
    it { is_expected.to validate_numericality_of(:quantity).is_greater_than_or_equal_to(0) }
  end

  describe "#total_price" do
    let(:product) { create(:product, price: 10.0) }
    let(:cart) { create(:cart) }
    let(:cart_item) { create(:cart_item, cart: cart, product: product, quantity: 2) }

    it "calculates the total price correctly" do
      expect(cart_item.total_price).to eq(20.0)
    end

    it "returns 0 if quantity is 0" do
      cart_item.update(quantity: 0)
      expect(cart_item.total_price).to eq(0)
    end
  end
end
