
class SponsorRestrictionsController < ApplicationController
  before_action :set_project

  def create
    @sponsor_restriction = @project.sponsor_restrictions.build(sponsor_restriction_params)
    if @sponsor_restriction.save
      flash[:notice] = "Sponsor Restriction was successfully created"
      redirect_to edit_project_path(@project)
    else
      flash[:error] =  @sponsor_restriction.errors.full_messages.join(', ')
    end
  end

  def edit
    @sponsor_restriction = @project.sponsor_restrictions.find(params[:id])
  end

  def new
    @sponsor_restriction = SponsorRestriction.new
  end


  def update
    @sponsor_restriction = @project.sponsor_restrictions.find(params[:id])
    if @sponsor_restriction.update(sponsor_restriction_params)
      flash[:notice] = "Sponsor Restriction was successfully updated"
      redirect_to edit_project_path(@project)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @sponsor_restriction = @project.sponsor_restrictions.find(params[:id])
    @sponsor_restriction.destroy
    flash[:notice] = "Sponsor Restriction was successfully deleted"
    redirect_to edit_project_path(@project)
  end

  private

  def set_project
    @project = Project.find(params[:project_id])
  end

  def sponsor_restriction_params
    params.require(:sponsor_restriction).permit(:restriction_type, :restriction_val)
  end
end

