class SponsorPreferencesController < ApplicationController
  before_action :set_project
  before_action :authorize_admin_or_prof, unless: -> { Rails.env.development? || Rails.env.test? }

  def create
    @sponsor_preference = @project.sponsor_preferences.build(sponsor_preference_params)
    if @sponsor_preference.save
      flash[:notice] = "Sponsor Preferences was successfully created"
      redirect_to edit_project_path(@project)
    else
      flash[:error] =  @sponsor_preference.errors.full_messages.join(', ')
      redirect_to new_project_sponsor_preference_path(@project)
    end
  end

  def edit
    @sponsor_preference = @project.sponsor_preferences.find(params[:id])
    set_restrictions
  end

  def new
    @sponsor_preference = SponsorPreference.new
    set_restrictions
  end

  def update
    @sponsor_preference = @project.sponsor_preferences.find(params[:id])
    if @sponsor_preference.update(sponsor_preference_params)
      redirect_to edit_project_path(@project), notice: "Sponsor preference updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @sponsor_preference = @project.sponsor_preferences.find(params[:id])
    @sponsor_preference.destroy
    flash[:notice] = "Sponsor preference deleted."
    redirect_to edit_project_path(@project)
  end

  private

  def set_project
    @project = Project.find(params[:project_id])
  end

  def sponsor_preference_params
    params.require("sponsor_preference").permit(:preference_type, :preference_val, :bonus_amount)
  end

  def set_restrictions
    @restrictions = {}
    @restrictions['gender'] = STUDENT_STATUS_CONSTANTS['gender']
    @restrictions['work_auth'] = STUDENT_STATUS_CONSTANTS['work_auth']
    @restrictions['contract_sign'] = STUDENT_STATUS_CONSTANTS['contract_sign']
    @restrictions['nationality'] = STUDENT_STATUS_CONSTANTS['nationality']

    @restrictions
  end
end
