class ApplicationController < ActionController::API
  #Kiểm tra authauthorize_request trước mỗi action
  before_action :authorize_request

  private  #nó sẽ private tất cả các method bên dưới
  #nếu muốn chỉ định method nào là private thì đặt private trước method đó
  #ví dụ private def jwt_secret

  #public - có thể gọi từ bên ngoài class
  #protected - chỉ có thể gọi từ bên trong class hoặc các class kế thừa
  #private - chỉ có thể gọi từ bên trong class hiện tại


  #Lấy sercret key để mã hoá và giải mã JWT token
  def jwt_secret
    # Tạm dùng secret_key_base của Rails tạm thời 
    Rails.application.secret_key_base
  end

  #hoặc có thể private :jwt_secret  # Chỉ method này private

  #Tạo JWT token từ payload(dữ liệu muốn lưu trong token)
  def encode_token (payload)
    #thêm hạn 24h 
    payload[:exp] = 24.hours.from_now.to_i
    JWT.encode(payload,jwt_secret, 'HS256')
  end

  #Giải mã JWT token, trả về payload hoặc nil nếu không hợp lệ
  def decode_token
    auth = request.headers['Authorization'] # Lấy header Authorization
    token = auth&.split(' ')&.last #Tách "Bearer <token>"
    return nil if token.blank? # sẽ đúng khi token là nil hoặc rỗng

    decoded = JWT.decode(token , jwt_secret,true,{algorithm: 'HS256'})
    # decoded là một array có 2 phần tử:
# [
#   {"user_id" => 1, "exp" => 1234567890},  # payload (dữ liệu)
#   {"alg" => "HS256", "typ" => "JWT"}      # header
# ]
    decoded.first # => hash payload
    # Trong Ruby, dòng cuối cùng của method sẽ tự động được return (không cần từ khóa return).
  rescue JWT::DecodeError, JWT::ExpiredSignature
    nil
  end

  #Kiểm tra quyền truy cập dựa trên JWT token
  def authorize_request
    data = decode_token
    if data && data['user_id']
       #instance variable có thể sử dụng trong controller và view trong suốt vòng đời request
      @current_user = User.find_by(id: data['user_id'])
      return if @current_user
    end
    render json: {error: 'Unauthorized'}, status: :Unauthorized
  end
end

#Save navigation 
# Cách viết ngắn gọn và an toàn
# token = auth&.split(' ')&.last

# Cách hoạt động:

# auth&.split(' ') - Chỉ gọi .split(' ') nếu auth không phải nil
# &.last - Chỉ gọi .last nếu kết quả trước đó không phải nil

# nó là cách viết ngắn gọn và an toàn để tránh lỗi khi auth là nil.

# Cách viết dài dòng và dễ lỗi
# if auth != nil
#   parts = auth.split(' ')
#   if parts != nil
#     token = parts.last
#   end
# end


  #Ví dụ sử dụng JWT gem
#   # Encode
# payload = {user_id: 1}
# token = JWT.encode(payload, 'secret', 'HS256')

# # Decode  
# decoded = JWT.decode(token, 'secret', true, {algorithm: 'HS256'})
# user_data = decoded.first  # => {"user_id" => 1}