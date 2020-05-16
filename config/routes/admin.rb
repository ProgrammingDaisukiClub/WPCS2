Rails.application.routes.draw do
  namespace :admin do
    resources :contests do
      resources :awards, only: %i[index]
      resources :submissions, :editorials
      member do
        get :json_upload
        patch :update_from_json
      end
    end
    resources :problems, :data_sets, only: %i[show new edit create update destroy]
    resources :users, only: %i[index show]
  end
end
