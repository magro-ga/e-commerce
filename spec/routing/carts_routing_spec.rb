# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CartsController, type: :routing do
  describe 'routes' do
    it 'routes to #show' do
      expect(get: '/cart').to route_to('carts#show')
    end

    it 'routes to #create' do
      expect(post: '/cart').to route_to('carts#create')
    end

    it 'routes to #add_items via POST' do
      expect(post: '/cart/add_items').to route_to('carts#create')
    end

    it 'routes to #delete_items via DELETE' do
      expect(delete: '/cart/1').to route_to('carts#destroy', product_id: '1')
    end
  end
end
