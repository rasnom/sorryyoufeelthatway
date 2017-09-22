Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

get '/', to: 'card_templates#index'

resources :card_templates, only: [:index] do
  resources :cards, only: [:new, :create]
end

end
