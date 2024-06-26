Rails.application.routes.draw do
  defaults format: :json do
    resources :games, only: [:index, :show] do
      collection do
        get "grouped_information"
        get "deaths_grouped_by_cause"
      end
    end
  end

  post "/uploaded-event", to: "webhook#handle_uploaded_event"
end
