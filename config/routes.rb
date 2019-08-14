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

  concern :commentable do
    resources :comments, only: [:create, :update, :destroy], shallow: true
  end

  resources :questions, concerns: [:votable, :commentable] do
    resources :answers, shallow: true, concerns: [:votable, :commentable] do
      member do
        post :best
      end
    end
  end

  root to: "questions#index"
  mount ActionCable.server => '/cable'
end
