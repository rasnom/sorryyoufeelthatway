Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get '/', to: 'card_templates#index'

  get '/congrats', to: 'static#congrats'

  resources :card_templates, only: [:index, :show] do
    resources :cards, only: [:create]
  end

  resources :charges

end
