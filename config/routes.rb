Rails.application.routes.draw do
  root to: 'welcome#index'
  get 'welcome/index'

  resources :trackers, only: %i[
    index show new create destroy
  ]
end