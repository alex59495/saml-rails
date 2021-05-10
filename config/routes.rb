Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: "application#index"
  get 'logged_in', to: "application#logged_in", as: :logged_in

  # SAML LOGIN SINGLE TENANT
  # post 'saml_login', to: "application#saml_login"
  # post 'saml_callback', to: "application#saml_callback"

  # SAML SSO MULTIPLE TENANT
  devise_scope :user do
    post '/auth/saml/:identity_provider_id/callback',
      to: 'omniauth_callbacks#saml',
      as: 'user_omniauth_callback'
    post '/auth/saml/:identity_provider_id',
      to: 'omniauth_callbacks#passthru',
      as: 'user_omniauth_authorize'
  end


  # GOOGLE AUTH
  get 'login', to: 'logins#new'
  get 'login/create', to: 'logins#create', as: :create_login
end
