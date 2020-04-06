Rails.application.routes.draw do
  root to: "pages#homepage"

  get "how_does_it_work", to: "pages#how_does_it_work"

  resources :trackers, only: %i[index show new create destroy] do
    member do
      post "sync"
    end
  end
end
