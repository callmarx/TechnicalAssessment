require 'rails_helper'

RSpec.describe "Webhooks", type: :request do
  describe "GET /handle_uploaded_event" do
    it "returns http success" do
      get "/webhook/handle_uploaded_event"
      expect(response).to have_http_status(:success)
    end
  end

end
