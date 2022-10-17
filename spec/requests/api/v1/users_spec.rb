# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Users', type: :request do
  let(:role) { create(:role) } # admin role
  let(:role2) { create(:role, name: 'normal user') } # not admin role
  let(:valid_attributes) { attributes_for(:user, role_id: 2) }
  let(:invalid_name) { attributes_for(:user, first_name: "", role_id: 2) }
  let(:invalid_password) { attributes_for(:user, password: '12345', role_id: 2) }
  let(:invalid_email) { attributes_for(:user, email: 'zapatillasgoat@gmail.com', role_id: 2) }
  let(:login_user1) do # admin user
    create(:user, password: 'password')
    post api_v1_auth_login_path,
         params: { user: { email: User.last.email, password: 'password' } }, as: :json
    JSON.parse(response.body, symbolize_names: true)
  end
  let(:login_user2) do # not admin user
    create(:user, password: 'password', role: role2)
    post api_v1_auth_login_path,
         params: { user: { email: User.last.email, password: 'password' } }, as: :json
    JSON.parse(response.body, symbolize_names: true)
  end
  let(:valid_headers) { { Authorization: login_user1[:token] } }
  let(:invalid_headers) { { Authorization: login_user2[:token] } }

  describe 'POST /create' do
    context 'with valid params' do
      it 'creates a new user' do
        roleid = create(:role, id: 2)
        post api_v1_auth_register_url,
             params: { user: valid_attributes }, as: :json
        expect(response).to have_http_status(:created)
      end

      it 'renders a JSON response' do
        roleid = create(:role, id: 2)
        post api_v1_auth_register_url,
             params: { user: valid_attributes }, as: :json
        expect(response.content_type).to match(a_string_including('application/json'))
      end
    end

    context 'with invalid params' do
      it 'Does not create a user with invalid name' do
        expect do
          roleid = create(:role, id: 2)
          post api_v1_auth_register_url,
               params: { user: invalid_name, role_id: 2 }, as: :json
        end.not_to change(User, :count)
      end

      it 'Does not create user with invalid password' do
        roleid = create(:role, id: 2)
        post api_v1_auth_register_url,
             params: { user: invalid_password }, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'Does not create user with already registered email' do
        roleid = create(:role, id: 2)
        create(:user, email: 'zapatillasgoat@gmail.com', role_id: 2)
        post api_v1_auth_register_url,
             params: { user: invalid_email }, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'POST /login' do
    context 'with valid user and password' do
      it 'logs in' do
        user = create(:user)
        post api_v1_auth_login_url,
             params: { user: { email: user.email, password: user.password } }, as: :json
        expect(response).to have_http_status(:ok)
      end

      it 'responds with a valid JWT' do
        user = create(:user)
        post api_v1_auth_login_url,
             params: { user: { email: user.email, password: user.password } }, as: :json
        token = JSON.parse(response.body)['token']
        expect { JsonWebToken.decode(token) }.not_to raise_error
      end
    end

    context 'with invalid params' do
      it 'responds unauthorized status with invalid email' do
        user = create(:user)
        post api_v1_auth_login_url,
             params: { user: { email: 'wrongemail@gmail.com', password: user.password } }, as: :json
        expect(response).to have_http_status(:unauthorized)
      end

      it 'responds unauthorized status with invalid password' do
        user = create(:user)
        post api_v1_auth_login_url,
             params: { user: { email: user.email, password: 'wrong_password' } }, as: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'GET /me' do
    it 'renders a successful response' do
      get api_v1_auth_me_url, headers: valid_headers, as: :json
      expect(response).to be_successful
    end

    it 'renders a JSON response' do
      get api_v1_auth_me_url, headers: valid_headers, as: :json
      expect(response.content_type).to match(a_string_including('application/json'))
    end
  end

  describe 'GET /index' do
    before { create_list :user, 5 }

    context 'with admin access' do
      it 'renders a succesful response' do
        get api_v1_users_url, headers: valid_headers, as: :json
        expect(response).to be_successful
      end

      it 'renders a JSON response' do
        get api_v1_auth_me_url, headers: valid_headers, as: :json
        expect(response.content_type).to match(a_string_including('application/json'))
      end
    end

    context 'without admin access' do
      it 'response forbidden status' do
        get api_v1_users_url, headers: invalid_headers, as: :json
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe 'PATCH /update' do
    context 'with valid attributes' do
      let(:new_attributes) do
        build(:user, first_name: 'new name', role: role)
      end

      it 'updates the user' do
        user = create(:user, password: 'password')
        post api_v1_auth_login_path,
             params: { user: { email: User.last.email, password: 'password' } }, as: :json
        parsed_body = JSON.parse(response.body, symbolize_names: true)
        ok_headers =  { Authorization: parsed_body[:token] }
        patch api_v1_user_url(user),
              params: { user: new_attributes }, headers: ok_headers, as: :json
        user.reload
        expect(user.first_name).to eq(new_attributes.first_name)
      end
    end

    context 'with invalid attributes' do
      let(:new_attributes) do
        build(:user, first_name: '', role: role)
      end

      it 'does not updates the user' do
        user = create(:user, password: 'password')
        post api_v1_auth_login_path,
             params: { user: { email: User.last.email, password: 'password' } }, as: :json
        parsed_body = JSON.parse(response.body, symbolize_names: true)
        ok_headers =  { Authorization: parsed_body[:token] }
        patch api_v1_user_url(user),
              params: { user: new_attributes }, headers: ok_headers, as: :json
        user.reload
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
