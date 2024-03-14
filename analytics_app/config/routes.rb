Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  # сколько заработал топ-менеджмент за сегодня и сколько попугов ушло в минус
  get 'top_management_profit', to: 'accounting#top_management_profit'

  # информации о собственных счетах (лог операций + текущий баланс)
  get 'me', to: 'accounting#me'

  # показывать самую дорогую задачу за день, неделю или месяц.
  get 'most_expensive_task', to: 'analytics#most_expensive_task'
end
