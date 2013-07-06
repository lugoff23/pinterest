Pinterest::Application.routes.draw do
  resources :posts
  devise_for :users, path: '', path_names: {
     sign_in: 'login',
     sign_out: 'logout',
     password: 'password',
     confirmation: 'confirmation',
     unlock: 'unlock',
     registration: '',
     sign_up: 'signup'
   }
   resources :users
   
   root to: 'posts#index'
 end
