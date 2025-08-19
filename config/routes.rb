Rails.application.routes.draw do
  namespace : api do
    namespace: v1 do
      resources: products
      #Giỏ hàng theo user_Id (đơn giản gửi kèm userID để gọi api )
      resource: cart, only: [:show] do
        post :add_item
        patch :update_item
        delete :remove_item
        post :checked_out
      end
    end
  end
end
