Rails.application.routes.draw do
  scope :admin do
    devise_for :admins, controllers: {
      confirmations: 'admin/admins/confirmations',
      passwords:     'admin/admins/passwords',
      registrations: 'admin/admins/registrations',
      sessions:      'admin/admins/sessions'
    }
  end
  namespace :admin do
    resources :contests do
      member do
        get 'submissions'
      end
    end
    resources :problems, :data_sets, only: %i(show new edit create update destroy)
  end
end
