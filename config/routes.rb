Rapidfire::Engine.routes.draw do
  resources :surveys do
    get 'results', on: :member

    resources :conditionals
    resources :questions do
      member do
        post :values
        post :conditional
      end
    end
    resources :attempts, only: [:new, :create, :edit, :update]
  end
end
