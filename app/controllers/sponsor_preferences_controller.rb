class SponsorPreferencesController < ApplicationController
  before_action :set_project

  def create
    @sponsor_preference = @project.sponsor_preferences.build(sponsor_preference_params)
    if @sponsor_preference.save
      flash[:notice] = "Sponsor Preferences was successfully created"
      redirect_to edit_project_path(@project)
    else
      flash[:error] =  @sponsor_restriction.errors.full_messages.join(', ')
    end
  end

  def edit
    @sponsor_preference = @project.sponsor_preferences.find(params[:id])
  end

  def new
    @sponsor_preference = SponsorPreference.new
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
end
