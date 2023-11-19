class AdminlandingController < ApplicationController
    before_action :authorize_admin
    def index
    end

    def configuration
    end

    def update_configuration
        @config = Config.first_or_initialize

        params[:form_open] = params[:form_open].in_time_zone('Central Time (US & Canada)').utc
        params[:form_close] = params[:form_close].in_time_zone('Central Time (US & Canada)').utc

        if @config.update(form_open: params[:form_open], form_close: params[:form_close], min_number: params[:min_number], max_number: params[:max_number])
            flash[:notice] = "Changes made successfully"
        else
            flash[:alert] = "Error updating the fields"
        end

        redirect_to configuration_path, status: :found
    end

    private
        def authorize_admin
            curr_user_id = session[:user_id]
            # print "[DEBUG] curr_user_id: #{curr_user_id}"
            if curr_user_id
                curr_user_role = User.find_by(user_id: curr_user_id).role
                # print "[DEBUG] curr_user_role: #{curr_user_role}"
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
