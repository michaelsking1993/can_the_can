Rails.application.routes.draw do
  root to: 'can_the_cans#input_can_type'

  get '/what_can_is_it/:sentence' => 'can_the_cans#get_can_type'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
