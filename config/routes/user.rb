Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'welcome#index'
  devise_for :users, controllers: {
    confirmations: 'users/confirmations',
    passwords: 'users/passwords',
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }
  resources :users, only: ['show']
  resources 'contests', only: ['show'] do
    resources 'problems', only: ['show'] do
      resources 'data_sets', only: ['show']
    end
    member do
      get 'ranking'
    end
    resources 'submissions', only: ['index']
    resources 'editorials', only: ['show']
  end

  resource 'terms', only: %w[show]
  resource 'privacy_policies', only: %(show)

  namespace :api do
    resources 'contests', only: %w[show] do
      member do
        post 'entry'
        get  'ranking'
        get  'status'
        post 'validation'
      end
      resources 'submissions', only: %w[index create]
    end
  end

  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?
end
