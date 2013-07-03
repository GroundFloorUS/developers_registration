Groundfloor::Application.routes.draw do
  
  # resources :investments
  match '/invest', to: "investments#new", :as => :invest
  
  
  # Developer Registration urls
  match '/profile', to: "registrations#create_account", :as => :create_account, :via => [:post]
  match '/profile', to: "registrations#delete_project", :as => :delete_project, :via => [:delete]
  match '/profile', to: "registrations#profile", :as => :profile, :via => [:get,:put,:post]
  match '/account', to: "registrations#account", :as => :account
  match '/projects', to: "registrations#projects", :as => :projects
  match '/thanks', to: "registrations#thanks", :as => :thanks
  
  # Devises Path
  # devise_scope :user do
  #   match '/auth/:provider/callback', to: 'groundfloor/sessions#auth_callback'
  #   match '/logout', to: 'groundfloor/sessions#destroy'  
  # end
  devise_for :users, :controllers => { :sessions => "groundfloor/sessions" }
  
  
  root :to => "cms_content#render_html"
  
  # CMS Admin path
  ComfortableMexicanSofa::Routing.admin(:path => '/cms-admin')
  
  # Active admin routes
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  
  # Make sure this routeset is defined last
  ComfortableMexicanSofa::Routing.content(:path => '/', :sitemap => false)
  
end
