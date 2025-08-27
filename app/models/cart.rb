class Cart < ApplicationRecord
  belongs_to :user
  has_many :cart_items, dependent: :destroy
  has_many :products, through: :cart_items

  enum status: {active: 0, checked_out: 1}
  #Lấy tổng tiền thời điểm hiện tại (tính theo giá sản phẩm hiển tại)
  def total_price
    cart_items.include(:product).sum{ |ci| ci.quantity * ci.product.price}
  end

  #Thêm / tăng số lượng 1 sản phẩm vào giỏ
  def add_product(product_id, quantity = 1)
    item = cart_items.find_or_initialize_by(product_id: product_id)
    item.quantity = (item.quantity || 0) + quantity.to_i      
    item.save!
    item
  end

  #Đổi số lượng 1 item 
  def set_item_quantity(product_id, qty)
    item = cart_items.find_by!(product_id: product_id)
    if qty.to_i <= 0
      item.destroy!
    else
      item.update!(quantity: qty.to_i)
    end
    item
  end
end
