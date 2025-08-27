class Api::V1::ProductsController < ApplicationController
  skip_before_action :authorize_request, only: [:index, :show]

  def index 
    @products = Product.all
    render json: @products
  end

  def show
    @product = Product.find(params[:id])
    render json: @product
    rescue ActiveRecord::RecordNotFound
      render json: {error: 'Product not found'} , status: :not_found
  end
end