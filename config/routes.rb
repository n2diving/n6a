Rails.application.routes.draw do
  resources :employee_teams
  resources :review_criteria
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  # root to: "home#index"
end
