Rails.application.routes.draw do
  resources :passwords, controller: "clearance/passwords", only: %i[create new]
  resource :session, controller: "clearance/sessions", only: [:create]

  resources :users, only: :create do
    resource :password, controller: "clearance/passwords", only: %i[edit update]
  end

  get "/sign_in" => "clearance/sessions#new", as: "sign_in"
  delete "/sign_out" => "clearance/sessions#destroy", as: "sign_out"
  get "/sign_up" => "clearance/users#new", as: "sign_up"

  root to: "pages#homepage"

  get "how_does_it_work", to: "pages#how_does_it_work"
  get "contact_us", to: "pages#contact_us"
  post "contact_us", to: "pages#send_contact"
  get "confirm_email/:token" => "email_confirmations#update", as: "confirm_email"

  resources :trackers
end
