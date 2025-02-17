# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "/products", type: :request do
  let(:valid_attributes) {
    { name: 'A product', price: 1 }
  }

  let(:invalid_attributes) {
    { name: '', price: -1 }
  }

  describe "GET /index" do
    it "renders a successful response" do
      Product.create! valid_attributes
      get products_url, as: :json
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      product = Product.create! valid_attributes
      get product_url(product), as: :json
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Product" do
        expect {
          post products_url, params: { product: valid_attributes }, as: :json
        }.to change(Product, :count).by(1)
      end

      it "renders a JSON response with the new product" do
        post products_url, params: { product: valid_attributes }, as: :json
        expect(response).to have_http_status(:created)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end

    context "with invalid parameters" do
      it "does not create a new Product" do
        expect {
          post products_url, params: { product: invalid_attributes }, as: :json
        }.to change(Product, :count).by(0)
      end

      it "renders a JSON response with errors for the new product" do
        post products_url, params: { product: invalid_attributes }, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) { { name: 'Updated name', price: 5 } }

      it "updates the requested product" do
        product = Product.create! valid_attributes
        patch product_url(product), params: { product: new_attributes }, as: :json
        product.reload
        expect(product.name).to eq('Updated name')
        expect(product.price).to eq(5)
      end

      it "renders a JSON response with the product" do
        product = Product.create! valid_attributes
        patch product_url(product), params: { product: new_attributes }, as: :json
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end

    context "with invalid parameters" do
      it "renders a JSON response with errors for the product" do
        product = Product.create! valid_attributes
        patch product_url(product), params: { product: invalid_attributes }, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested product" do
      product = Product.create! valid_attributes
      expect {
        delete product_url(product), as: :json
      }.to change(Product, :count).by(-1)
    end
  end
end
