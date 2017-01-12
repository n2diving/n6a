Rails.application.routes.draw do
  resources :employee_reviewers
  resources :review_items_by_roles
  resources :review_items
  resources :review_notes
  resources :teams
  resources :employee_teams
  resources :review_item
  resources :user_reviews

  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  devise_scope :user do
    authenticated :user do
      root 'users#show', as: :authenticated_root
    end

    unauthenticated do
      root 'devise/sessions#new', as: :unauthenticated_root
    end
  end

  root 'users#show'


  get    '/users(.:format)',           to: 'users#index',            as: :users
  post   '/users(.:format)',           to: 'users#create'
  get    '/users/new(.:format)',       to: 'users#new',              as: :new_user
  get    '/users/:id/edit(.:format)',  to: 'users#edit',             as: :edit_user
  get    '/users/:id(.:format)',       to: 'users#show',             as: :user
  patch  '/users/:id(.:format)',       to: 'users#update'
  put    '/users/:id(.:format)',       to: 'users#update'
  delete '/users/:id(.:format)',       to: 'users#destroy'
  get   '/new_employee_rating/:id(.:format)',        to: 'users#new_employee_rating',     as: :new_employee_rating
  get   '/edit_employee_rating/:id(.:format)',  to: 'users#edit_employee_rating',     as: :edit_employee_rating
  post   '/employee_rating',          to: 'users#employee_rating',     as: :employee_rating
  patch   '/employee_rating',          to: 'users#employee_rating'
  patch   '/update_all',              to: 'users#update_all',     as: :update_all
  put   '/update_all',              to: 'users#update_all'
  post   '/update_all',              to: 'users#update_all'
  patch   '/update_all_team',              to: 'users#update_all_team',     as: :update_all_team
  put   '/update_all_team',              to: 'users#update_all_team'
  post   '/update_all_team',              to: 'users#update_all_team'
  get   '/new_team_rating',            to: 'users#new_team_rating',     as: :new_team_rating
  get   '/edit_team_rating/:id(.:format)',            to: 'users#edit_team_rating',     as: :edit_team_rating
  patch   '/team_rating',      to: 'users#team_rating',     as: :team_rating
  post   '/team_rating',      to: 'users#team_rating'
  get   '/employees_with_pending_reviews',            to: 'users#employees_with_pending_reviews',     as: :employees_with_pending_reviews


  get   '/edit_team_reviews',            to: 'teams#edit_team_reviews',     as: :edit_team_reviews



  # get    '/review_criteria(.:format)',                                 to: 'review_criteria#index',            as: :review_criterias
  # post   '/review_criteria(.:format)',                                 to: 'review_criteria#create'
  # get    '/review_criteria/new(.:format)',                             to: 'review_criteria#new',              as: :new_review_criteria
  # get    '/review_criteria/:id/edit(.:format)',                        to: 'review_criteria#edit',             as: :edit_review_criteria
  # get    '/review_criteria/:id(.:format)',                             to: 'review_criteria#show',             as: :review_criteria
  # patch  '/review_criteria/:id(.:format)',                             to: 'review_criteria#update'
  # put    '/review_criteria/:id(.:format)',                             to: 'review_criteria#update'
  # delete '/review_criteria/:id(.:format)',                             to: 'review_criteria#destroy'

end