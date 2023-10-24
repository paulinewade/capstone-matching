class ChangeweightsController < ApplicationController
    def index
        @score_attributes = ScoresAttribute.all
    end

    def save_change
        feature_weights = params[:feature_weights]

        total = feature_weights.sum do |weight|
            weight.gsub('%', '').to_f
          end
    
        if total != 100
            flash[:error] = "Weights do not add up to 100%, try again."
            redirect_to changeweights_path
            return
        end

        if feature_weights.present?
            feature_weights.each_with_index do |weight, index|
                # Remove the '%' character and convert the weight to a float
                parsed_weight = weight.gsub('%', '').to_f / 100.0

                # Find the corresponding record by index and update it
                attribute_id = index + 1  # Assuming attribute_id starts from 1 and increments by 1
                score_attribute = ScoresAttribute.find_by(attribute_id: attribute_id)

                if score_attribute
                    score_attribute.update(feature_weight: parsed_weight)
                else
                    # Handle the case where no record with the given attribute_id is found.
                    flash[:alert] = "No record found for attribute_id: #{attribute_id}."
                    redirect_to root_path
                    return
                end
            end
            flash[:success] = "Feature weights updated successfully."
        else
            flash[:error] = "No feature weights provided for update."
        end
        redirect_to changeweights_path
    end
end