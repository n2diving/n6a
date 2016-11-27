Rails.application.routes.draw do
  resources :review_notes
  resources :teams
  resources :employee_teams
  resources :review_criteria
  resources :user_reviews

  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  devise_scope :user do
    authenticated :user do
      root 'users#index', as: :authenticated_root
    end

    unauthenticated do
      root 'devise/sessions#new', as: :unauthenticated_root
    end
  end

  root 'users#index'


  get    '/users(.:format)',                                 to: 'users#index',            as: :users
  post   '/users(.:format)',                                 to: 'users#create'
  get    '/users/new(.:format)',                             to: 'users#new',              as: :new_user
  get    '/users/:id/edit(.:format)',                        to: 'users#edit',             as: :edit_user
  get    '/users/:id(.:format)',                             to: 'users#show',             as: :user
  patch  '/users/:id(.:format)',                             to: 'users#update'
  put    '/users/:id(.:format)',                             to: 'users#update'
  delete '/users/:id(.:format)',                             to: 'users#destroy'

end