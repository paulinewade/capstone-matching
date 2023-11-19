class ProfLandingController < ApplicationController
    before_action :authorize_professor
    def index
    end

    private
        def authorize_professor
            curr_user_id = session[:user_id]
            print "[DEBUG] curr_user_id: #{curr_user_id}"
            if curr_user_id
                curr_user_role = User.find_by(user_id: curr_user_id).role
                print "[DEBUG] curr_user_role: #{curr_user_role}"
                if curr_user_role != "professor" and curr_user_role != "admin"
                    flash[:error] = 'Access Denied'
                    redirect_to root_path
                end
            else
                flash[:error] = 'Access Denied'
                redirect_to root_path
            end
        end
end
