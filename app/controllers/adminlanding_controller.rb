class AdminlandingController < ApplicationController
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
end
