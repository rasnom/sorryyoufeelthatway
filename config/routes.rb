Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get '/', to: 'card_templates#index'

  get '/congrats', to: 'static#congrats'

  get '/admin', to: 'admin#index'

  resources :card_templates, only: [:index] do
    resources :cards, except: [:index, :destroy]
  end

  resources :charges, only: [:create]

  resources :sessions, only: [:new, :create, :destroy]
end
