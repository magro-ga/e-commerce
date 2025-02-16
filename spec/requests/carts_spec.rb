require 'rails_helper'

RSpec.describe "/carts API", type: :request do
  let!(:cart) { Cart.create }
  let!(:product) { Product.create(name: 'Mouse', price: 49.90) }

  before { allow_any_instance_of(ApplicationController).to receive(:session).and_return({ cart_id: cart.id }) }

  describe "POST /cart" do
    let!(:cart_item) { CartItem.create(cart: cart, product: product, quantity: 1) }

    context 'when the product already is in the cart' do
      subject do
        post '/cart/add_items', params: { product_id: product.id, quantity: 1 }, as: :json
        post '/cart/add_items', params: { product_id: product.id, quantity: 1 }, as: :json
      end

      it 'updates the quantity of the existing item in the cart' do
        expect { subject }.to change { cart_item.reload.quantity }.by(2)
      end
    end
  end
end
