class AdminlandingController < ApplicationController
    before_action :authorize_admin, unless: -> { Rails.env.development? || Rails.env.test? }
    def index
        if session[:user_id]
            @current_user = User.find_by(user_id: session[:user_id])
            @first_name = @current_user.first_name
            @last_name = @current_user.last_name
        end
    end

    def configuration
    end

    def update_configuration
        @config = Config.first_or_initialize
      
        # Convert semester dates to UTC
        params[:fall_semester_day] = params[:fall_semester_day].to_i
        params[:spring_semester_day] = params[:spring_semester_day].to_i
        params[:summer_semester_day] = params[:summer_semester_day].to_i

        params[:fall_semester_month] = params[:fall_semester_month].to_i
        params[:spring_semester_month] = params[:spring_semester_month].to_i
        params[:summer_semester_month] = params[:summer_semester_month].to_i

        if semester_order_valid? && @config.update(
            form_open: params[:form_open],
            form_close: params[:form_close],
            min_number: params[:min_number],
            max_number: params[:max_number],
            fall_semester_day: params[:fall_semester_day],
            fall_semester_month: params[:fall_semester_month],
            spring_semester_day: params[:spring_semester_day],
            spring_semester_month: params[:spring_semester_month],
            summer_semester_day: params[:summer_semester_day],
            summer_semester_month: params[:summer_semester_month]
          )
          flash[:notice] = "Changes made successfully"
        else
          flash[:error] = "Error updating the fields, ensure that dates are in the correct order and that all fields have values."
        end
      
        redirect_to configuration_path
      end
    
    private

    def semester_order_valid?
      year = Time.current.year
      spring_date = build_date(year, params[:spring_semester_month], params[:spring_semester_day])
      summer_date = build_date(year, params[:summer_semester_month], params[:summer_semester_day])
      fall_date = build_date(year, params[:fall_semester_month], params[:fall_semester_day])
    
      if spring_date && summer_date && fall_date && spring_date < summer_date && summer_date < fall_date
        return true
      else
        return false
      end
    end
    
    def build_date(year, month, day)
      Date.new(year, month.to_i, day.to_i) rescue nil
    end
end
