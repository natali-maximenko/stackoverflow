Rails.application.routes.draw do
  resources :questions, only: [:index, :new, :create, :show] do
    resources :answers, only: [:index, :new, :create, :show]
  end
end
