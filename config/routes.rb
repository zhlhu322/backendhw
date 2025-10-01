Rails.application.routes.draw do
  resources :missions
  # ADMIN
  namespace :admin do
    resources :missions
    resources :users do
      member do
        resources :missions, only: [ :index ]
      end
    end
    get "sign_up", to: "registrations#new"
    get "sign_in", to: "sessions#new"
    post "sign_in", to: "sessions#create"
    delete "logout", to: "sessions#destroy"
  end

  # USER
  get "sign_up", to: "registrations#new"
  post "sign_up", to: "registrations#create"

  delete "logout", to: "sessions#destroy"

  get "sign_in", to: "sessions#new"
  post "sign_in", to: "sessions#create"

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "sessions#new"
end
