Rails.application.routes.draw do
  if Rails.env.development?
    resources 'react_tutorial', only: ['index']
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
