# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::News', type: :request do
  let(:login_user) do
    create(:user, password: 'password')
    post api_v1_auth_login_path,
         params: { user: { email: User.last.email, password: 'password' } }, as: :json
    JSON.parse(response.body, symbolize_names: true)
  end
  let(:category) { create(:category) }
  let(:valid_headers) { { Authorization: login_user[:token] } }
  # byebug
  let(:valid_attributes) { build(:news, category: category) }
  let(:invalid_attributes) { build(:news, name: '', category: category) }

  describe 'GET /show' do
    it 'renders a successful response' do
      news = create(:news)
      get api_v1_news_url(news), headers: valid_headers, as: :json
      expect(response).to be_successful
    end
  end

  describe 'POST /create' do
    context 'with valid params' do
      it 'creates a new news' do
        expect do
          post api_v1_news_index_url,
               params: { news: valid_attributes }, headers: valid_headers, as: :json
        end.to change(News, :count).by(1)
      end

      it 'returns a created status' do
        post api_v1_news_index_url,
             params: { news: valid_attributes }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:created)
      end

      it 'renders a JSON response' do
        post api_v1_news_index_url,
             params: { news: valid_attributes }, headers: valid_headers, as: :json
        expect(response.content_type).to match(a_string_including('application/json'))
      end
    end

    context 'with invalid params' do
      let(:invalid_content) { build(:news, content: '', category: category) }

      it 'Does not create a new news with invalid name' do
        expect do
          post api_v1_news_index_url,
               params: { news: invalid_attributes }, headers: valid_headers, as: :json
        end.not_to change(News, :count)
      end

      it 'Does not create a new news with invalid content' do
        expect do
          post api_v1_news_index_url,
               params: { news: invalid_content }, headers: valid_headers, as: :json
        end.not_to change(News, :count)
      end

      it 'renders a JSON response with errors for the new category' do
        post api_v1_news_index_url,
             params: { news: invalid_attributes }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PATCH /update' do
    context 'with valid params' do
      let(:new_attributes) do
        build(:news, name: 'new name ', content: 'new content', category: category)
      end

      it 'updates the news' do
        news = create(:news)
        patch api_v1_news_url(news),
              params: { news: new_attributes }, headers: valid_headers, as: :json
        news.reload
        expect(news.name).to eq(new_attributes.name)
      end

      it 'render a JSON response' do
        news = create(:news)
        patch api_v1_news_url(news),
              params: { news: new_attributes }, headers: valid_headers, as: :json
        expect(response.content_type).to match(a_string_including('application/json'))
      end

      it 'returns OK status' do
        news = create(:news)
        patch api_v1_news_url(news),
              params: { news: new_attributes }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid params' do
      let(:new_attributes) { build(:news, name: '', content: '', category: category) }

      it 'Does not create a new news with invalid parameter' do
        news = create(:news)
        patch api_v1_news_url(news),
              params: { news: new_attributes }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE /destroy' do
    it 'destroys the requested news' do
      news = create(:news)
      expect do
        delete api_v1_news_url(news), headers: valid_headers, as: :json
      end.to change(News, :discarded)
    end

    it 'responds no content' do
      news = create(:news)
      delete api_v1_news_url(news), headers: valid_headers, as: :json
      expect(response).to have_http_status(:no_content)
    end
  end
end
