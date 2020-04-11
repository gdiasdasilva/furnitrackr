Rails.application.routes.draw do
  root to: "pages#homepage"

  get "how_does_it_work", to: "pages#how_does_it_work"
  get "contact_us", to: "pages#contact_us"
  post "contact_us", to: "pages#send_contact"

  resources :trackers, only: %i[index show new create destroy] do
    member do
      post "sync"
    end
  end
end
