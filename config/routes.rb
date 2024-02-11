Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  root "home#show"

  resources :sponsors, only: [:index]
  resources :tickets, only: [:show]
  resources :speakers, only: [:index]
  resources :checkouts, only: [:index, :show, :create]
  resources :subscribers, only: [:new, :show, :create, :destroy]
  resource :thanks, only: [:show]

  namespace :webhooks do
    resource :stripe, only: [:create]
  end

  namespace :admin do
    root "dashboards#show"
    resource :login, only: [:show, :create]
    resources :orders, only: [:show] do
      collection do
        get :report
      end
    end
  end

  direct(:twitter) { "https://twitter.com/@balkanruby" }
  direct(:facebook) { "https://facebook.com/balkanruby" }
  direct(:youtube) { "https://www.youtube.com/@balkanruby6171" }
  direct(:banitsa) { "https://rubybanitsa.com" }
  direct(:neuvents) { "https://neuvents.com" }
  direct(:cfp) { "https://forms.gle/NJY9PJWpud39ZQAr8" }
  direct(:cfp_responses) { "https://docs.google.com/spreadsheets/d/1A5BSvPOznCgHC9sbXpYelbjSVjIwODYCs0e1onNEyxU/edit?usp=sharing" }
end
