require 'rails_helper'

RSpec.describe "Webhooks", type: :request do
  describe 'POST /uploaded-event' do
    context 'with valid payload' do
      let(:payload) do
        {
          "Records" => [
            {
              "s3" => {
                "object" => {
                  "key" => "example_object_key"
                },
                "bucket" => {
                  "name" => "example_bucket_name"
                }
              },
              "responseElements" => {
                "x-minio-origin-endpoint" => "example_endpoint"
              }
            }
          ]
        }.to_json
      end

      before do
        allow(LogProcessJob).to receive(:perform_async)
      end

      it 'calls LogProcessJob with correct file_url' do
        post '/uploaded-event', params: payload

        expect(LogProcessJob).to have_received(:perform_async).with('http://minio:9000/example_bucket_name/example_object_key')
      end

      it 'returns HTTP status 200' do
        post '/uploaded-event', params: payload

        expect(response).to have_http_status(:ok)
      end
    end

    context 'with missing necessary information in the payload' do
      let(:payload_missing_info) do
        {
          "Records" => [
            {
              "s3" => {
                "object" => {
                  "not-a-key" => "example_object_key"
                },
                "bucket" => {
                  "name" => "example_bucket_name"
                }
              },
              "responseElements" => {
                "x-minio-origin-endpoint" => "example_endpoint"
              }
            }
          ]
        }.to_json
      end

      it 'returns HTTP status 422' do
        post '/uploaded-event', params: payload_missing_info

        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns error message in response body' do
        post '/uploaded-event', params: payload_missing_info

        expect(JSON.parse(response.body)).to eq({ "error" => "Unable to find necessary information in the payload." })
      end
    end

    context 'with invalid payload' do
      let(:invalid_payload) { {}.to_json }

      it 'returns HTTP status 422' do
        post '/uploaded-event', params: invalid_payload

        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns error message in response body' do
        post '/uploaded-event', params: invalid_payload

        expect(JSON.parse(response.body)).to eq({ "error" => "Payload does not contain records or is not in the expected format." })
      end
    end

    context 'with invalid JSON payload' do
      let(:invalid_json_payload) { 'invalid_json' }

      it 'returns HTTP status 400' do
        post '/uploaded-event', params: invalid_json_payload

        expect(response).to have_http_status(:bad_request)
      end

      it 'returns error message in response body' do
        post '/uploaded-event', params: invalid_json_payload

        expect(JSON.parse(response.body)).to eq({ "error" => "Error parsing JSON payload: unexpected token at 'invalid_json'" })
      end
    end
  end
end
