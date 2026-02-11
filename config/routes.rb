# Add these routes to your config/routes.rb

Rails.application.routes.draw do
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "dashboard#index"

  # Dashboard
  get "dashboard", to: "dashboard#index"
  
  # Notifications
  get "notifications", to: "notifications#index"
  
  # Tasks
  get "tasks", to: "tasks#index"
  resources :tasks, except: [:index]
  
  # Calendars
  get "calendars", to: "calendars#index"
  
  # Analytics
  get "analytics", to: "analytics#index"
  
  # Contacts
  resources :contacts
  
  # Companies
  resources :companies
  
  # Deals
  resources :deals
  
  # Integrations
  get "integrations", to: "integrations#index"
  
  # Settings
  get "settings", to: "settings#index"
  
  # Kanban
  get "kanban", to: "kanban#index"
  
  # Figma Demo (temporary)
  get "figma_demo", to: "figma#demo"
  
  # Devise routes (authentication)
  devise_for :users
end