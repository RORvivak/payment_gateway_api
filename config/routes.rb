Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
	resources :gateways, only: [] do
		collection do
  		post :message_generator
  		post :transaction
		end
	end
end
