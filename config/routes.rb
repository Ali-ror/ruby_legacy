RelyLocal::Application.routes.draw do
  devise_for :users, :controllers => {:registrations => "registrations"}

  namespace :mobile_api do
    resources :territories, :only => [ :index, :show ] do
      resources :business_listings, :only => [ :index, :show ] do
        get 'search', :on => :collection
        member do
          get 'meet_the_owner'
          get 'files'
          get 'coupons'
          get 'rewards'
          get 'photos'
        end
        resources :reviews, :only => [ :index, :create ]
      end
      resources :events, :only => :index
      resources :daily_deals, :only => :index do
        post 'toggle_subscription', :on => :collection
      end
      resources :rewards, :only => :index do
        get 'resellers', :on => :collection
      end
      resources :coupons, :only => :index
    end
    resources :sessions
    resources :registrations
  end

  namespace "admin" do
    resources :administrators
    resources :categories do
      member do
        get "hide"
      end
    end
    resources :users
    resources :reports do
      collection do
        get "territories"
        get "paid_listing_users"
      end
    end

    resources :territories do
      resources :users
      resources :categories
      resources :headers
      resources :banners
      resources :sub_pages
      resources :daily_deals

      resource :featured_listings
      resource :featured_owners
      resource :featured_mobiles

      resources :events do
        member do
          get "accept"
          get "reject"
        end
      end

      resources :comments, :only => [:index] do
        member do
          get "accept"
          get "reject"
        end
      end

      resources :pictures, :only => [:index] do
        member do
          get "accept"
          get "reject"
        end
      end

      resources :business_listings do
        resources :comments
        resources :file_models
        resources :pictures
        resources :rewards

        resources :coupons do
          post "sort", :on => :collection
        end

        member do
          get "accept"
          get "reject"
          get "feature"
          get "publish"
          get "unpublish"
        end
      end

      member do
        get "reset_default_text"
        get "docs_help"
        get "mass_email"
        post "send_mass_email"
      end
    end

    root :to => "territories#index"

    match "business_listings" => "business_listings#index"
  end

  root :to => "pages#national"

  match "/national"               => "pages#national",  :as => "national"
  match "/states"                 => "states#index",    :as => "states"
  match "/states/:state/cities"   => "cities#index",    :as => "state_cities"
  match "/rewards"                => "pages#rewards"#,   :as => "rewards"
  match "/shift"                  => "pages#occupy_main_street", :as => "occupy_main_street"

  match "/national/occupy-main-street", :to => redirect("/shift")

  match "/occupy_facebook" => "facebook#occupy_facebook"

  match "/page/:page"  => "pages#page", :as => "page"

  scope "/:territory_id", :as => "territory" do
    root :to => "pages#home"

    # Pages that are not dynamic and to be listed in a territory, but you want to reuse the page templates
    scope :controller => "pages", :action => "page" do
      match "/how-relylocal-works",     :page => "how_relylocal_works",     :as => "how_relylocal_works"
      match "/terms-of-use",            :page => "terms_of_use",            :as => "tos"
      match "/privacy-policy",          :page => "privacy_policy",          :as => "privacy_policy"
      match "/copyright",               :page => "copyright",               :as => "copyright"
      match "/rely-local-national",     :page => "rely_local_national",     :as => "rely_local_national"
      match "/your-local-business",     :page => "your_local_business",     :as => "your_local_business"
    end

    match "/advertise-with-us"        => "pages#advertise_with_us",       :as => "advertise_with_us"
    match "/promote-your-business"    => "pages#promote_your_business",   :as => "promote_your_business"
    match "/what-is-relylocal"        => "pages#what_is_relylocal",       :as => "what_is_relylocal"
    match "/contact-us"               => "pages#contact_us",              :as => "contact_us"
    match "/show-your-support"        => "pages#show_your_support",       :as => "show_your_support"
    match "/jobs"                     => "pages#jobs",                    :as => "jobs"
    match "/impact-of-local-spending" => "pages#impact_of_local_spending",:as => "impact_of_local_spending"

    resources :coupons, :only => [:index]
    resources :events,  :only => [:index, :new, :create]

    match "/rewards/LocalRewards" => "rewards#all", :as => "rewards_pdf"
    resources :rewards, :only => [:index, :show, :toggle_subscription, :all] do
      collection do
        get 'toggle_subscription'
        get 'all'
      end
    end
    match "/toggle_subscription" => "rewards#toggle_subscription", :as => "toggle_subscription"

    resources :rewards_card_resellers, :only => [:index]
    match "/buy-local-rewards" => "rewards_card_resellers#index"

    match "/business_listings/search" => "business_listings#search", :via => [:get, :post], :as => "search"

    resources :business_listings, :only => [:index, :show, :new, :create] do
      resources :coupons,   :only => [:show]
      resources :comments,  :only => [:create]
      get "mobile_qrcode", :on => :member
    end

    #resources :categories, :only => [:index]

    match "/businesses"                                => "categories#index",         :as => "categories"
    match "/coupons/*categories"                       => "coupons#index",            :as => "coupons_category"
    match "/rewards/filter/*categories"                => "rewards#index",            :as => "rewards_category"
    match "/categories/*categories/business_listings"  => "business_listings#index",  :as => "category"

    match "/submit-business" => "business_listings#new", :as => "submit_business"

    match "/:sub_page"  => "pages#sub_page",  :as => "sub_page"
  end


end
