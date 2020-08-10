Rails.application.routes.draw do
  use_doorkeeper
  root to: 'questions#index'

  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }
  
  concern :votable do
    member do
      post :down
      post :up
      post :cancel_vote
    end
  end

  resources :questions, concerns: :votable do
    resources :answers, shallow: true, concerns: :votable do
      member do
        post :select_best
      end
  	end
  end
  resources :rewards, only: :index
  resources :attachments, only: :destroy
  resources :links, only: :destroy
  resources :comments, only: %i[create destroy]

  namespace :api do
    namespace :v1 do
      resources :profiles, only: [:index] do
        get :me, on: :collection
      end
      resources :questions, only: [:index, :show], shallow: true do
        resources :answers, only: [:index, :show]
      end
    end
  end

  mount ActionCable.server => '/cable'
end
