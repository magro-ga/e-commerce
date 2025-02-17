# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Product, type: :model do
  describe "validations" do
    it "is valid with a name and a positive price" do
      product = described_class.new(name: "Produto Teste", price: 100)
      expect(product).to be_valid
    end

    it "is invalid without a name" do
      product = described_class.new(price: 10.0)
      expect(product).to_not be_valid
      expect(product.errors[:name]).to include("can't be blank")
    end

    it "is invalid without a price" do
      product = described_class.new(name: "Produto Teste")
      expect(product).to_not be_valid
      expect(product.errors[:price]).to include("can't be blank")
    end

    it "is invalid with a negative price" do
      product = described_class.new(name: "Produto Teste", price: -5)
      expect(product).to_not be_valid
      expect(product.errors[:price]).to include("must be greater than or equal to 0")
    end
  end
end
