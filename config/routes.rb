Rails.application.routes.draw do

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # devise_for :admin_users, ActiveAdmin::Devise.config
  # ActiveAdmin.routes(self)
  get 'sign_in', :to=> 'sessions#new', :as => :new_session
  post 'sign_in', :to=> 'sessions#create'
  delete 'sign_out', :to => 'sessions#destroy'

  use_doorkeeper

  devise_for :users, :skip => [:sessions], :controllers => {
    registrations: 'registrations',
                                       }

  # root 'campaigns#index'

  devise_scope :user do
    # root to: "users/sessions#new"
    post 'states', :to => 'registrations#states'
    post 'cities', :to => 'registrations#cities'
    post '/api/v1/verify_account', :to => 'registrations#verify_account'
    get 'user/:token/confirm', :to => 'registrations#confirm_user'
    get '/api/v1/area_of_interest', :to => 'registrations#area_of_interest'
    get '/api/v1/project_coordinators', :to => 'registrations#project_coordinators'
    get '/api/v1/access_token', :to => 'registrations#access_token'
    get 'charities_list', :to => 'registrations#charities_list'
    get '/api/v1/all_emails', to: 'registrations#all_emails'
    get '/api/v1/check_wallet', to: 'registrations#check_wallet'
    get '/api/v1/tasks', to: 'registrations#tasks'
    get '/api/v1/update_status', to: 'campaigns#update_status'
    get 'request_activation_email/:email', to: 'registrations#request_activation_email'
  end

  # get 'cryptoapis-cb-a9e3431240e85e31fade63e5d3c3826da5555d1c0d13649b33343bca104eff74.txt', :to=> 'campaigns#verify_domain'
  # post '/transaction_callback', :to=> 'campaigns#transaction_callback'

  # namespace :api, defaults: { formate: 'json' } do
  namespace :api do
    namespace :v1 do
      resources :volunteers
      resources :nft_files, only: [:show]
      resources :nfts do
        collection do
          get 'fetch_nfts'
        end
      end
      resources :videos, only: [:index, :create, :update] do
        get 'remove_video' => 'videos#remove_video', on: :member
        post 'upload_image' => 'videos#upload_image', on: :collection
      end
      resources :transactions, only: [:create]
      resources :campaigns do
        collection do
          get :user_campaigns
        end
      end
      resource :campaign_check_in_histories
      post 'volunteer_applier' => 'campaigns#volunteer_applier'
      get 'volunteer_interest/:campaign_slug/accept/:apply_slug' => 'campaigns#accept_request'
      get "campaign_completed/:id" => 'campaigns#campaign_completed'
      get "wallet_address/:id" => 'campaigns#wallet_address'
      post "volunteer_applier_paid" => 'campaigns#volunteer_applier_paid'
      resources :chatrooms
      get 'add_users' => 'chatrooms#add_users'
      delete 'remove_users' => 'chatrooms#remove_users'
      get 'chatroom_users' => 'chatrooms#chatroom_users'
      resources :messages
      post 'group_message' => 'messages#group_message'
      get 'countries' => 'coordinators#countries'
      resources :users
      post 'update_password' => 'users#update_password'
      get 'forget_password' => 'users#forget_password'
      post 'update_user' => 'users#update_user'
      get 'user_detail' => 'users#user_detail'
      get 'unread_messages' => 'users#unread_messages'
      get 'all_users_emails' => 'users#all_users_emails'
      post 'open_ai_images' => 'users#open_ai_images'
      post 'update_database' => 'users#update_database'
    end

    scope '(v:version)', format: false, defaults: { format: :json, version: 1 }, constraints: { version: /[1]/ } do
      post 'get_volunteered_projects' => 'coordinators#get_volunteered_projects'
      post 'check_in' => 'coordinators#check_in'
      post 'check_out' => 'coordinators#check_out'
      get 'volunteer/:id' => 'coordinators#select_volunteer'
      get 'goods_wallet_balance' => 'coordinators#goods_wallet_balance'

      namespace :users do
        controller :registrations do
          post :sign_up, action: :create
          get :all_emails, action: :all_emails
          get :tasks, action: :tasks
        end
        controller :sessions do
          delete :sign_out, action: :destroy
          post :sign_in, action: :create
        end
      end
      get 'get_coordinators' => 'coordinators#coordinators_list'
      post 'append_message' => 'messages#append_message'
    end
  end

  # get 'calendar' => 'events#index'
  # resources :events,      only:  [:new, :create, :show] do
  #     resources :attendees,   only:  [:new, :create]
  #     resource :download_badges_pdf, only: [:show]
  # end
  # resources :alliances, path: 'charities',   only:  [:index, :show, :edit, :update]
  # resources :vendors,   only:  [:index, :show, :edit, :update]
  # resources :churches,    only:  [:index, :show, :edit, :update]
  # resources :users,       only:  [:edit, :update]
  # resources :payments,    only:  [:new, :create]
  # resources :ads,         only:  [:new, :create, :edit, :update]
  scope :admin do
    resources :invites, only: :index
  end
  # resources :cards,       only:  [:new, :create, :edit, :update]
  # resources :need_contributions, only: [:create]
  resources :volunteer_appliers, only: [:create]
  # resources :messages, only: [:create]


  # post 'append_message' => 'messages#append_message'

  resources :messages do
    collection do
      get :get_messages
      post :create_message
    end
    
  end
  
  # resources :products do
  #   collection do
  #     get :user_products
  #   end
  #   member do
  #     delete :destroy_product_media
  #   end
  # end

  # resources :campaigns do
  #   collection do
  #     get :user_campaigns
  #     get :project_categories
  #     # get :winner
  #     # get :showing_wallet
  #     post :send_amount
  #     post :receive_amount
  #   end
  #   member do
  #     delete :destroy_campaign_media
  #     get :get_need
  #     post :create_message
  #   end
  #   resources :campaign_donations, only: [:new, :create]
  #   resources :nfts
  # end

  # resources :charitable_donations, only: [:new, :create]

  # resources :chamber_donations, only: [:new, :create]

  # resources :needs,       only: [:new, :create, :show] do
  #   resources :resources,          only: [:new, :create]
  # end

  # resources :resources,   only: [:new, :create] do
  #   get :accept, on: :member
  # end

  # resources :volunteers do
  #   member do
  #     put :get_volunteer
  #   end
  # end

  # resources :votes

  # Subscription cancel
  # get 'payments/cancel_subscription' , as: :cancel_subscription


  # campaign customized routes

  get 'coordinator/campaigns' => 'campaigns#coordinator_campaigns'

  # Temporary Hidden
  # resources :job_leads, only: [:new, :create]

  # get 'dashboard(/:user_id)' => 'users#dashboard', as: :dashboard
  # get 'rewards'=> 'home#rewards'
  # get 'currency-of-good'=> 'home#currency_of_good'
  #----------------7 Tool Box Links ------------------
  # get 'tool_boxes' => 'tool_boxes#index'
  # get 'tool_box' => 'tool_boxes#show'
  # get 'documents' => 'tool_boxes#documents'
  # get 'tool_box_resources' => 'tool_boxes#resources'
  # get 'tool_box_events' => 'tool_boxes#events'
  # volunteer management

  get 'volunteer_interest/:campaign_id' => 'campaigns#volunteer_interest'
  get 'volunteer_interest/:campain_id/accept/:volunteer_id' => 'campaigns#accept_request'
  get 'volunteer/campaigns' => 'campaigns#user_accepted_campaigns'
  post 'api/v1/volunteer' => 'volunteers#create'

  # get 'blog' => 'tool_boxes#blog', as: :blog
  #--------------------------------------------------

  # #---------------- Invite  Links ------------------
  # get "invite/new" => 'invite#new', :as => :new_invite
  # post "invite/create" => 'invite#create', :as => :invites
  # #---------------------------------------------------

  # get 'docs' => 'home#save_docs'

  # get 'contact_us' =>  'contact_form#new'
  # resources "contact_forms", only: [:new, :create]
end
