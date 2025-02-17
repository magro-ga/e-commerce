class CartsController < ApplicationController
  include ActionController::Cookies

  before_action :set_cart

  def create
    product = Product.find(params[:product_id])
    cart_item = @cart.cart_items.find_or_initialize_by(product: product)

    cart_item.quantity += params[:quantity].to_i

    if cart_item.save
      render json: { cart: @cart, products: @cart.cart_items }, status: :created
    else
      render json: { error: 'Could not add product to cart' }, status: :unprocessable_entity
    end
  end

  def show
    render json: cart_response(@cart)
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
    cart_id = cookies[:cart_id]  # Tenta pegar o cart_id do cookie
    
    if cart_id.present? && Cart.exists?(cart_id)  # Verifica se o cart_id existe e é válido
      @cart = Cart.find(cart_id)  # Se o cart_id existir, encontra o carrinho
    else
      @cart = Cart.create!  # Caso não, cria um novo carrinho
      cookies[:cart_id] = { value: @cart.id, expires: 1.year.from_now }  # Salva o ID do carrinho no cookie com expiração de 1 ano
    end
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
