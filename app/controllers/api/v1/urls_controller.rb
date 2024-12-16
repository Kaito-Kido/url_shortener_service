class Api::V1::UrlsController < ApplicationController
  def encode
    url = Url.find_or_initialize_by(original_url: params[:url])

    if url.new_record? && url.save
      render json: { short_url: short_url_for(url) }, status: :created
    elsif url.persisted?
      render json: { short_url: short_url_for(url) }, status: :ok
    else
      render json: { error: url.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def decode
    if invalid_shorten_url?(params[:short_url])
      return render json: { error: "Invalid shorten URL" }, status: :unprocessable_entity
    end

    url = Url.find_by(short_code: short_code_from_url)

    if url
      render json: { url: url.original_url }, status: :ok
    else
      render json: { error: "URL not found" }, status: :not_found
    end
  end

  private

  def short_url_for(url)
    "#{request.base_url}/#{url.short_code}"
  end

  def short_code_from_url
    params[:short_url].split("/").last
  end

  def invalid_shorten_url?(url)
    allowed_domains = if Rails.env.production?
                        [ Rails.application.credentials.production[:domain] ]
    elsif Rails.env.test?
                        [ "test.host" ]
    else
                        [ "localhost", "127.0.0.1" ]
    end

    valid_url_pattern = /\Ahttps?:\/\/(#{allowed_domains.join('|')})(:\d+)?\/[a-zA-Z0-9_-]+\z/

    begin
      uri = URI.parse(url)

      return true unless allowed_domains.include?(uri.host) && %w[http https].include?(uri.scheme)

      return false if url.match?(valid_url_pattern)
    rescue URI::InvalidURIError
      return true
    end

    true
  end
end
