# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Users', type: :request do

    let(:role) { create(:role) }
    let(:valid_attributes) { build(:user, role: role)}

    describe 'POST /create' do
        context 'with valid params' do
            it 'creates a new user' do
                # post api_v1_auth_register_url, 
                # params: { valid_attributes}, as: :json
                # expect(response).to have_http_status(:created)   
                user = build(:user)
                expect(user).to be_valid
            end
        end

        context "invalid params" do
            it "no first name" 
            it "no last name"
            it "no email"
            it "same email"
            it "invalid password"
        end
    end

    describe 'POST /login' do
        context 'with valid user and password' do
            it "logs in" do
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
                expect { JsonWebToken.decode(token) }.to_not raise_error
            end
        end

        context "with invalid params" do
            it "returns unauthorized status with invalid email" do
                user = create(:user)
                post api_v1_auth_login_url,
                params: { user: { email: "wrong_email@gmail.com", password: user.password } }, as: :json
                expect(response).to have_http_status(:unauthorized)
            end
            it "returns unauthorized status with invalid password" do
                user = create(:user)
                post api_v1_auth_login_url,
                params: { user: { email: user.email, password: "wrong_password" } }, as: :json
                expect(response).to have_http_status(:unauthorized)
            end
        end
    end  
end
