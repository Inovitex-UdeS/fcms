Fcms::Application.routes.draw do
devise_for :users, :controllers => {:registrations => 'devise_registrations', :invitations => 'users/invitations'}

  root :to => "home#index"

   namespace :admin do
     # Directs /admin/x/* to Admin::xsController
     # (app/controllers/admin/xs_controller.rb)
     get '', to: 'dashboard#index', as: '/'
     get '/home', to: 'dashboard#home'

     resources :accompanists
     resources :cities
     resources :editions
     resources :instruments
     resources :rooms
     resources :teachers
     resources :composers
     resources :schools
     resources :schoolboards
     resources :schooltypes
     resources :registrations
     resources :settings
     resources :users
     resources :pieces
     resources :agegroups
     resources :planification
     resources :timeslots
     resources :categories
     resources :participants
     resources :custom_mails

     resources :juges do
       member do
         get 'confirm'
         get 'reject'
       end
     end

     match 'planif_excel' => 'planification#ProduceExcel'
     match 'users_excel' => 'users#ProduceExcel'
   end

  resources :categories
  resources :users

  resources :registrations do
    member do
      get 'cancel'
    end
  end

  resources :composers

  get 'autocomplete/cities'
  get 'autocomplete/schools'
  get 'autocomplete/pieces'
  get 'autocomplete/users'
  get 'autocomplete/composers'
  get 'autocomplete/participants'
  get 'autocomplete/teachers'
  get 'autocomplete/accompanists'

  get 'users/juges/new', to: 'users#new', as: '/juges/new'

  get 'upgrade', to: 'upgrade#index'

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
