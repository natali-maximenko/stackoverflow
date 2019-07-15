Rails.application.routes.draw do
  devise_for :users
  resources :files, only: :destroy
  resources :links, only: :destroy
  resources :questions do
    resources :answers, shallow: true do
      member do
        post :best
      end
    end
  end

  root to: "questions#index"
end
