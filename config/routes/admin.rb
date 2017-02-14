Rails.application.routes.draw do
  scope :admin do
    devise_for :admins
  end
end
