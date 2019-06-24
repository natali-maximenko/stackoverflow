Rails.application.routes.draw do
  devise_for :users
  resources :questions, only: [:index, :new, :create, :show] do
    resources :answers, only: [:index, :new, :create, :show]
  end

  root to: "questions#index"
end
