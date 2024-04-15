# frozen_string_literal: true

class WebhookController < ApplicationController
  def handle_uploaded_event
    payload = JSON.parse(request.body.read)
    Rails.logger.info "Payload received from MinIO: #{payload}"

    if payload["Records"].present? && payload["Records"].is_a?(Array)
      record = payload["Records"].first
      object_key = record.dig("s3", "object", "key")
      endpoint = record.dig("responseElements", "x-minio-origin-endpoint")
      bucket = record.dig("s3", "bucket", "name")

      if endpoint.present? && bucket.present? && object_key.present?
        # # Construct the URL to access the file
        # file_url = "#{endpoint}/#{bucket}/#{object_key}"
        # # Since we are inside the docker, endpoint must be the minio docker service name
        file_url = "http://minio:9000/#{bucket}/#{object_key}"
        Rails.logger.info "URL to access the file: #{file_url}"
 
        file = URI.open(file_url)
        QuakeLog::Parser.new(file).perform
      else
        Rails.logger.error "Unable to find necessary information in the payload."
      end
    else
      Rails.logger.error "Payload does not contain records or is not in the expected format."
    end

    head :ok
  rescue JSON::ParserError => e
    Rails.logger.error "Error parsing JSON payload: #{e.message}"
    head :bad_request
  end
end
