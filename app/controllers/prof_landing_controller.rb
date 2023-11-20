class ProfLandingController < ApplicationController
    before_action :authorize_admin_or_prof, unless: -> { Rails.env.development? || Rails.env.test? }
    def index
    end
end
