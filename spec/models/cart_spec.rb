# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Cart, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:cart_items).dependent(:destroy) }
  end

  describe '#total_price' do
    let(:cart) { create(:cart, :with_items) }
    let(:product) { create(:product, price: 10.0) }

    before do
      create(:cart_item, cart: cart, product: product, quantity: 2)
      create(:cart_item, cart: cart, product: product, quantity: 3)
    end

    it 'calculates the total price of the cart' do
      expected_price = cart.cart_items.sum { |item| item.quantity * item.product.price }
      expect(cart.total_price).to eq(expected_price)
    end

    it 'returns zero if the cart has no items' do
      empty_cart = create(:cart)
      expect(empty_cart.total_price).to eq(0)
    end
  end

  describe '#mark_as_abandoned' do
    let(:cart) { create(:cart) }

    it 'marks the cart as abandoned if inactive for more than 3 hours' do
      cart.update(last_interaction_at: 4.hours.ago)
      expect { cart.mark_as_abandoned }.to change { cart.status }.from('active').to('abandoned')
    end

    it 'does not change status if interacted recently' do
      cart.update(last_interaction_at: 1.hour.ago)
      expect { cart.mark_as_abandoned }.not_to change { cart.status }
    end
  end

  describe '#remove_if_abandoned' do
    let(:abandoned_cart) { create(:cart, :old_abandoned) }

    it 'removes the cart if abandoned for more than 7 days' do
      abandoned_cart.mark_as_abandoned
      expect { abandoned_cart.remove_if_abandoned }.to change { Cart.count }.by(-1)
    end

    it 'does not remove the cart if abandoned for less than 7 days' do
      recent_abandoned_cart = create(:cart, :abandoned)
      expect { recent_abandoned_cart.remove_if_abandoned }.not_to change { Cart.count }
    end
  end
end
