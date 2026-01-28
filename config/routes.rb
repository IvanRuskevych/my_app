Rails.application.routes.draw do
  # get "home/index"
  get "/home", to: "home#index"

  # test.localhost.com => use constraints()
  constraints(lambda { |request| request.host.match(/\W+/) }) do
    # root to: "home#blog", as: :subdomain_root
    root to: "home#blog", as: nil?
  end

  # root to: "home#index"

  scope :blog do
    resources :posts, only: [:index, :show] do
      member do
        resources :comments
      end
      get "/search/:query", to: "home#search", on: :collection
    end
    # resources :posts, except: [:show]
    # resources :posts
    # get "/index", to: "posts#index"

    # TODO: localhost:3000/blog/posts/first_blog_post = post_id
    # get "/show/post_id", to: "posts#show"
  end

  namespace :admin do
    resources :posts
  end

  # auth
  get "/auth", to: "application#auth"
  get "/otp_form", to: "application#otp_form"
  get '/reset', to: 'application#reset_verification'

  root "application#otp_form"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
