Rails.application.routes.draw do
  devise_for :users
  resources :files, only: :destroy
  resources :links, only: :destroy
  resources :rewards, only: :index

  concern :votable do
    member do
      post :like
      post :dislike
    end
  end

  resources :questions, concerns: :votable do
    resources :answers, shallow: true, concerns: :votable do
      member do
        post :best
      end
    end
  end

  root to: "questions#index"
end
