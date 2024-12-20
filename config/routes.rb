Rails.application.routes.draw do
  get "healthz" => "infra#health"
  get "version" => "infra#version"

  root "home#show"
  get "2024", to: "home#retrospective", as: :retro2024

  resources :sponsors, only: [:new, :index]
  resources :tickets, only: [:show]
  resources :speakers, only: [:index]
  resources :talks, only: [:show]
  resources :checkouts, only: [:index, :show, :create]
  resources :subscribers, only: [:new, :show, :create, :destroy]
  resources :blogs, only: [:show]
  resource :thanks, only: [:show]
  resource :slides, only: [:show]

  namespace :webhooks do
    resource :stripe, only: [:create]
  end

  namespace :admin do
    root "dashboards#show"
    get "/current/orders", to: "dashboards#orders", as: :current_orders
    resource :login, only: [:show, :create]
    resources :tickets, only: [:index]
    resources :orders, only: [:index, :show, :update] do
      collection do
        get :report
      end
      member do
        post :invoice
      end
    end
    resources :events, only: [] do
      resources :ticket_types, only: [:index, :show, :new, :create, :edit, :update]
      resources :embeddings, only: [:index, :show, :new, :create, :edit, :update]
      resources :lineup_members, only: [:index, :show, :new, :create, :edit, :update]
      resources :community_partners, only: [:index, :show, :new, :create, :edit, :update]
      resources :subscribers, only: [:index]
      resource :schedule, only: [:show, :new, :create, :edit, :update]
    end
    resources :speakers
    resources :talks
  end

  direct(:twitter) { "https://twitter.com/@balkanruby" }
  direct(:facebook) { "https://facebook.com/balkanruby" }
  direct(:youtube) { "https://www.youtube.com/@balkanruby6171" }
  direct(:banitsa) { "https://rubybanitsa.com" }
  direct(:banitsa_twitter) { "https://twitter.com/@rubybanitsa" }
  direct(:banitsa_facebook) { "https://facebook.com/rubybanitsa" }
  direct(:banitsa_youtube) { "https://www.youtube.com/playlist?list=PLdorvCkWvyys-G8zXg1-bCHKULzUX-uyT" }
  direct(:banitsa_contact) { "mailto:hi@rubybanitsa.com" }
  direct(:neuvents) { "https://neuvents.com" }
  direct(:cfp2025) { "https://forms.gle/Wzp4QvDzAiWVrB7d9" }
  direct(:cfp2024) { "https://forms.gle/NJY9PJWpud39ZQAr8" }
  direct(:cfp2024_responses) { "https://docs.google.com/spreadsheets/d/1A5BSvPOznCgHC9sbXpYelbjSVjIwODYCs0e1onNEyxU/edit?usp=sharing" }
  direct(:cfp2025_responses) { "https://docs.google.com/spreadsheets/d/1-aFGdBqVMQkP5JJq-1g-VyRUuvpYc_ZKBSct9cMvuA0/edit?usp=sharing" }
  direct(:slack) { "https://join.slack.com/t/balkanruby/shared_invite/zt-2fijcgv90-wR5zAhcpC1qKPcV9waZjbw" }
  direct(:balkan2025) { "https://balkanruby.com" }
end
