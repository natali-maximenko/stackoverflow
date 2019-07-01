Rails.application.routes.draw do
  devise_for :users
  resources :questions, only: [:index, :new, :create, :show, :destroy] do
    resources :answers, shallow: true
  end

  root to: "questions#index"
end
