class ProfLandingController < ApplicationController
    before_action :authorize_admin_or_prof
    def index
    end
end
