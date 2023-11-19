class ChangeweightsController < ApplicationController
    before_action :authorize_admin
    def index
        @score_attributes = ScoresAttribute.all
    end

    def save_weights
        feature_weights = params[:feature_weights]
        if feature_weights.nil?
            flash[:error] = "No feature weights to save."
            redirect_to changeweights_path
            return
        end
        total = feature_weights.sum do |weight|
            weight.to_f
        end
      
        if total != 100
            flash[:error] = "Weights do not add up to 100%, try again."
            redirect_to changeweights_path
            return
        end

        
        feature_weights.each_with_index do |weight, index|
            parsed_weight = weight.to_f / 100.0

            attribute_id = index + 1
            score_attribute = ScoresAttribute.find_by(attribute_id: attribute_id)

            if score_attribute
                score_attribute.update(feature_weight: parsed_weight)
            else
                # Handle the case where no record with the given attribute_id is found.
                flash[:error] = "No record found for attribute_id: #{attribute_id}."
                redirect_to changeweights_path
                return
            end
        end
        flash[:success] = "Feature weights updated successfully."
        redirect_to changeweights_path
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