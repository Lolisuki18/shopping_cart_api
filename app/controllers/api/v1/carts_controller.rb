class Api::V1::CartsController < ApplicationController

  before_action :find_or_create_cart

  def show 
    render json:{
      cart: @cart,
      items: @cart.cart_items.includes(:product).map do |item|
        {
          id: item.id,
          product: item.product,
          quantity: item.quantity,
          subtotal: item.quantity * item.product.price
        }
      end,
      total_price: @cart.total_price
    }
  end
  def add_item
    product = Product.find(params[:product_id])
    quantity = params[:quantity] || 1

    # Sử dụng set_product_quantity thay vì add_product
    item = @cart.set_product_quantity(product.id, quantity)
    render json: {
      message: 'Item added successfully',
      item: item,
      cart_total: @cart.total_price
    }
  rescue ActiveRecord::RecordNotFound
    render json: {error: 'Product not found'}, status: :not_found
  end
  
  def update_item
    item = @cart.set_item_quantity(params[:product_id], params[:quantity])
    render json: {
      message: 'Item updated successfully',
      item: item,
      cart_total: @cart.total_price
    }
  rescue ActiveRecord::RecordNotFound
    render json: {error: 'Item not found in cart' }, status: :not_found
  end

  def remove_item 
      @cart.set_item_quantity(params[:product_id], 0)
      render json: {message: 'Item removed successfully', cart_total: @cart.total_price}
       rescue ActiveRecord::RecordNotFound
    render json: { error: 'Item not found in cart' }, status: :not_found
  end

  def checkout
    @cart.update!(status: :checked_out)
    render json: {
      message: 'Checkout successful',
      cart: @cart,
      total_price: @cart.total_price
    }
  end

  private
  
  def find_or_create_cart
    @cart = @current_user.carts.active.first || @current_user.carts.create!(status: :active)
  end
end