class ApplicationController < ActionController::Base

    def authorize_admin_or_prof
        curr_user_id = session[:user_id]
        if curr_user_id
            curr_user_role = User.find_by(user_id: curr_user_id).role
            if curr_user_role != "admin" && curr_user_role != "professor"
                flash[:error] = 'Access Denied'
                redirect_to root_path
            end
        else
            flash[:error] = 'Access Denied'
            redirect_to root_path
        end
    end

    def authorize_admin
        curr_user_id = session[:user_id]
        if curr_user_id
            curr_user_role = User.find_by(user_id: curr_user_id).role
            if curr_user_role != "admin"
                flash[:error] = 'Access Denied'
                redirect_to root_path
            end
        else
            flash[:error] = 'Access Denied'
            redirect_to root_path
        end
    end
end
