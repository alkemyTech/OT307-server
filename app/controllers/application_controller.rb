# frozen_string_literal: true

class ApplicationController < ActionController::API
  include Authorization
  include Sendeable
  include Authenticable
  include Uploadable
  include Pagy::Backend
end
