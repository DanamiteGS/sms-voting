Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "campaigns#index" # Present a list of campaigns for which we have results.

  get "/:campaign", to: "campaigns#show_results", as: :show_campaign_results
end
