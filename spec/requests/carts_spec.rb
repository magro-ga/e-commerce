# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CartsController, type: :controller do
  let(:product) { create(:product, price: 10.0) }
  let(:cart) { create(:cart) }
  let(:cart_item) { create(:cart_item, cart: cart, product: product, quantity: 1) }

  before do
    cookies[:cart_id] = cart.id
    allow(controller).to receive(:set_cart).and_call_original
  end

  describe 'POST #create' do
    context 'when the cart is empty' do
      it 'adds a product to the cart' do
        post :create, params: { product_id: product.id, quantity: 2 }
        cart.reload
        expect(cart.cart_items.count).to eq(1)
        expect(cart.cart_items.first.quantity).to eq(3)
        expect(response).to have_http_status(:created)

        expect(cookies[:cart_id]).to eq(cart.id.to_s)
      end
    end

    context 'when the product is already in the cart' do
      it 'increments the quantity of the product in the cart' do
        cart_item
        post :create, params: { product_id: product.id, quantity: 2 }
        cart.reload
        expect(cart.cart_items.count).to eq(1)
        expect(cart.cart_items.first.quantity).to eq(3)
        expect(response).to have_http_status(:created)
      end
    end

    context "when adding multiple products to the cart" do
      let(:product1) { create(:product) }
      let(:product2) { create(:product) }

      it "keeps the same cart and adds new products" do
        post :create, params: { product_id: product1.id, quantity: 2 }
        json_response = JSON.parse(response.body)
        cart_id = json_response["cart"]["id"]
    
        post :create, params: { product_id: product2.id, quantity: 3 }
        json_response = JSON.parse(response.body)
    
        expect(json_response["cart"]["id"]).to eq(cart_id) # Garante que o carrinho é o mesmo
        expect(json_response["products"].size).to eq(2) # Confirma que dois produtos foram adicionados
      
        expect(cookies[:cart_id]).to eq(cart_id.to_s)
      end
    end
  end

  describe 'GET #show' do
    it 'returns the cart details' do
      get :show
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['id']).to eq(cart.id)
      expect(cookies[:cart_id]).to eq(cart.id.to_s)
    end
  end

  describe 'PUT #update' do
    it 'updates the quantity of a product in the cart' do
      cart_item
      put :update, params: { product_id: product.id, quantity: 5 }
      expect(cart_item.reload.quantity).to eq(5)
      expect(response).to have_http_status(:ok)
    end

    it 'returns an error if the product is not in the cart' do
      put :update, params: { product_id: product.id, quantity: 5 }
      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)['error']).to eq('Item não encontrado no carrinho')
    end
  end

  describe 'DELETE #destroy' do
    it 'removes a product from the cart' do
      cart_item
      delete :destroy, params: { product_id: product.id }
      expect(cart.cart_items.count).to eq(0)
      expect(response).to have_http_status(:ok)
    end

    it 'returns an error if the product is not in the cart' do
      delete :destroy, params: { product_id: product.id }
      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)['error']).to eq('Item não encontrado no carrinho')
    end
  end
end
