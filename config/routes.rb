Rails.application.routes.draw do
devise_for :users, defaults: { format: :json }, controllers: {
registrations: "users/registrations",
sessions: "users/sessions"
}


devise_scope :user do
post "/signup", to: "users/registrations#create"
post "/login", to: "users/sessions#create"
delete "/logout", to: "users/sessions#destroy"
end


resources :users, only: [ :index ]


resources :conversations, only: [ :index, :create, :show ] do
resources :messages, only: [ :index, :create ]
end
end
