class CartsController < ApplicationController
  before_action :set_cart

  def show
    render json: cart_response(@cart)
  end

  def create
    product = Product.find(params[:product_id])
    cart_item = @cart.cart_items.find_or_initialize_by(product_id: product.id)
    cart_item.quantity += params[:quantity].to_i
    cart_item.save!

    render json: cart_response(@cart), status: :created
  end

  def update
    cart_item = @cart.cart_items.find_by(product_id: params[:product_id])
    return render json: { error: "Item não encontrado no carrinho" }, status: :not_found unless cart_item

    cart_item.update(quantity: params[:quantity])
    render json: cart_response(@cart)
  end

  def destroy
    cart_item = @cart.cart_items.find_by(product_id: params[:product_id])
    return render json: { error: "Item não encontrado no carrinho" }, status: :not_found unless cart_item

    cart_item.destroy
    render json: cart_response(@cart)
  end

  private

  def set_cart
    @cart = Cart.find_or_create_by(id: session[:cart_id]) || Cart.create!
    session[:cart_id] = @cart.id
  end

  def cart_response(cart)
    {
      id: cart.id,
      products: cart.cart_items.map do |item|
        {
          id: item.product.id,
          name: item.product.name,
          quantity: item.quantity,
          unit_price: item.product.price,
          total_price: item.total_price
        }
      end,
      total_price: cart.total_price
    }
  end
end
