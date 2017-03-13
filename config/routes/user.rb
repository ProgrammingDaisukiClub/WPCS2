Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'welcome#index'
  devise_for :users, controllers: {
    confirmations: 'users/confirmations',
    passwords:     'users/passwords',
    registrations: 'users/registrations',
    sessions:      'users/sessions'
  }
  resources 'contests', only: ['show'] do
    resources 'problems', only: ['show']
    member do
      get 'ranking'
    end
  end

  namespace :api do
    resources 'contests', only: %w(show) do
      member do
        post 'entry'
        get  'ranking'
      end
      resources 'submissions', only: %w(index create)
    end
  end

  namespace :api do
    resources 'contests', only: %w(show) do
      member do
        post 'entry'
        get  'ranking'
      end
      resources 'submissions', only: %w(index create)
    end
  end

  mathjax 'mathjax'

  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?

  # if Rails.env.development?
  resources 'react_tutorial', only: ['index']
  # end
end
