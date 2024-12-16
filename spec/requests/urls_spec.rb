# spec/controllers/api/v1/urls_controller_spec.rb
require 'rails_helper'

RSpec.describe Api::V1::UrlsController, type: :controller do
  let(:valid_url) { 'http://someurl.com/some-path' }
  let(:invalid_url) { 'http://example.com/some-path' }
  let(:url) { create(:url, original_url: valid_url) }

  describe 'POST #encode' do
    context 'when the URL does not exist' do
      it 'creates a new URL and returns a short URL' do
        post :encode, params: { url: valid_url }

        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)['short_url']).to match(/http:\/\/test.host\//)
      end
    end

    context 'when the URL already exists' do
      it 'returns the existing short URL' do
        post :encode, params: { url: url.original_url }

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['short_url']).to match(/http:\/\/test.host\//)
      end
    end

    context 'when the URL is invalid' do
      it 'returns an error' do
        post :encode, params: { url: 'invalid-url' }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['error']).to include("Original url must be a valid URL")
      end
    end
  end

  describe 'GET #decode' do
    context 'when the short URL is valid' do
      it 'returns the original URL' do
        short_url = "#{request.base_url}/#{url.short_code}"

        get :decode, params: { short_url: short_url }
        byebug
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['url']).to eq(url.original_url)
      end
    end

    context 'when the short URL is invalid' do
      it 'returns an error' do
        get :decode, params: { short_url: 'http://test.host/invalid_code' }

        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)['error']).to eq("URL not found")
      end
    end

    context 'when the short URL has an invalid domain' do
      it 'returns an error' do
        get :decode, params: { short_url: 'http://example.com/invalid_code' }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['error']).to eq("Invalid shorten URL")
      end
    end
  end
end
