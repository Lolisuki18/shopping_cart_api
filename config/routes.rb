Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # API routes
  namespace :api do  # ✅ Sửa: namespace : api → namespace :api
    namespace :v1 do  # ✅ Sửa: namespace: v1 → namespace :v1
      # Authentication routes
      post '/auth/login', to: 'auth#login'
      post '/auth/register', to: 'auth#register'
      
      # Products routes  
      resources :products, only: [:index, :show]  # ✅ Sửa: resources: products → resources :products
      
      # Cart routes
      resource :cart, only: [:show] do  # ✅ Sửa: resource: cart → resource :cart
        member do
          post :add_item
          patch :update_item
          delete :remove_item
          post :checkout  # ✅ Sửa: checked_out → checkout (phải khớp với method trong controller)
        end
      end
    end
  end
end