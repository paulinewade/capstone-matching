class ProfLandingController < ApplicationController
    before_action :authorize_admin_or_prof, unless: -> { Rails.env.development? || Rails.env.test? }
    def index
        @current_user = User.find_by(user_id: session[:user_id])
        @first_name = @current_user.first_name
        @last_name = @current_user.last_name
    end
end
