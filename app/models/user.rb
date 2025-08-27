class User < ApplicationRecord
  has_many :carts, dependent: :destroy
  has_secure_password # dùng bcrypt để mã hóa mật khẩu
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
end