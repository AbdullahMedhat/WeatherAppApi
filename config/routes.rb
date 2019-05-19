Rails.application.routes.draw do
  delete '/erase',   to: 'weathers#erase'
  get    '/weather', to: 'weathers#index'
  post   '/weather', to: 'weathers#create'
end
