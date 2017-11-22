Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get '/', to: 'card_templates#index'

  get '/admin', to: 'admin#index'

  get '/admin/signout', to: 'sessions#destroy'

  get '/support', to: 'cards#support'

  resources :card_templates, only: [:index] do
    resources :cards, except: [:index, :destroy]
  end

  resources :charges, only: [:create]

  resources :sessions, only: [:create, :destroy]
end
