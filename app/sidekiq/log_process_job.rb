# frozen_string_literal: true

class LogProcessJob
  include Sidekiq::Job

  def perform(file_url)
    file = URI.open(file_url)

    QuakeLog::Parser.new(file).perform
  rescue OpenURI::HTTPError => e
    Rails.logger.error "HTTPError: #{e}"
  end
end
