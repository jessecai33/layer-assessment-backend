Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post '/games/search', to: 'games#search'
    end
  end
end
