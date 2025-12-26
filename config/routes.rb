Rails.application.routes.draw do
  get "healthz" => "infra#health"
  get "version" => "infra#version"

  root "home#show"

  resources :sponsors, only: [:new, :index] do
    collection do
      get :prospectus
    end
  end
  resources :tickets, only: [:show]
  resources :speakers, only: [:index]
  resources :talks, only: [:show]
  resources :checkouts, only: [:index, :show, :create]
  resources :subscribers, only: [:new, :show, :create, :destroy]
  resources :blogs, only: [:index, :show]
  resource :thanks, only: [:show]
  resource :slides, only: [:show]
  resource :apply, only: [:show]

  namespace :webhooks do
    resource :stripe, only: [:create]
  end

  namespace :admin do
    root "dashboards#show"
    get "/current/orders", to: "dashboards#orders", as: :current_orders
    resource :login, only: [:show, :create]
    resources :markdown_previews, only: [:create]
    resources :orders, only: [:index, :show, :update] do
      collection do
        get :report
      end
      member do
        post :invoice
      end
    end
    resources :events, only: [:index, :show, :new, :create, :edit, :update] do
      member do
        post :thumbnail
      end

      resources :tickets, only: [:index] do
        collection do
          post :giveaway
        end
        member do
          post :email
        end
      end
      resources :ticket_types, only: [:index, :show, :new, :create, :edit, :update]
      resources :embeddings, only: [:index, :show, :new, :create, :edit, :update]
      resources :lineup_members, only: [:index, :show, :new, :create, :edit, :update]
      resources :blog_posts, only: [:index, :show, :new, :create, :update]
      resources :community_partners, only: [:index, :show, :new, :create, :edit, :update, :destroy]
      resources :subscribers, only: [:index, :destroy]
      resources :sponsorship_packages, only: [:index, :show, :new, :create, :edit, :update]
      resources :sponsorships, only: [:index, :show, :new, :create, :edit, :update]
      resource :schedule, only: [:show, :new, :create, :edit, :update]
      resource :media_gallery, only: [:show, :new, :create, :edit, :update]
      resources :announcements, only: [:index, :show, :new, :create, :edit, :update] do
        member do
          post :activate
          post :deactivate
        end
      end
      resources :communications, only: [:index, :show, :new, :create]
    end
    resources :speakers, only: [:index, :show, :new, :create, :edit, :update]
    resources :sponsors, only: [:index, :show, :new, :create, :edit, :update]
    resources :talks, only: [:index, :show, :new, :create, :edit, :update]
    resources :venues, only: [:index, :show, :new, :create, :edit, :update]
    resources :invoice_sequences, only: [:index]
    resources :users, only: [:index, :show, :new, :create, :update, :destroy]
    resources :communication_drafts, only: [:index, :show, :new, :create, :edit, :update, :destroy] do
      collection do
        post :preview
      end
    end
  end

  direct(:banitsa) { "https://rubybanitsa.com" }
  direct(:github) { "https://github.com/gsamokovarov/balkan" }
  direct(:neuvents) { "https://neuvents.com" }
  direct(:slack) { "https://join.slack.com/t/balkanruby/shared_invite/zt-2fijcgv90-wR5zAhcpC1qKPcV9waZjbw" }
end
