class Api::V1::AuthController < ApplicationController
  skip_before_action :authorize_request, only: [:login, :register]

  def login 
    user = User.find_by(email: params[:email])
    
    if user&.authenticate(params[:password])
      token = encode_token({user_id: user.id})
      render json: {
        message: 'Login successful',
        token: token,
        user: {id: user.id, name: user.name, email: user.email}
      }
    else
      render json: {error: "Invalid credentials"}, status: :unauthorized
    end
  end

  def register 
    user = User.new(user_params)

    if user.save
      token = encode_toklen(user_id: user.id)
      render json:{
        message: 'Registration succesfull',
        token: token,
        user: {id: user.id, name: user.name, email: user.email}
      }
    else
      render json: {errors: user.errors.full_messages}, status: :unprocessable_entity
    end
  end
  private 
  def user_params
     params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
  
end