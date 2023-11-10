class AdminlandingController < ApplicationController
    def index
    end

    def open_close_student_form
    end

    def update_open_close_student_form
        @config = Config.first_or_initialize

        params[:form_open] = params[:form_open].in_time_zone('Central Time (US & Canada)').utc
        params[:form_close] = params[:form_close].in_time_zone('Central Time (US & Canada)').utc

        if @config.update(form_open: params[:form_open], form_close: params[:form_close])
            flash[:notice] = "Changes made successfully"
        else
            flash[:alert] = "Error updating the fields"
        end

        redirect_to open_close_student_form_path, status: :found
    end
end
