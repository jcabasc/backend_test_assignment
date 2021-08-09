Rails.application.routes.draw do
  namespace :api do
    resources :car_recommendations, only: [:index]
  end
end
