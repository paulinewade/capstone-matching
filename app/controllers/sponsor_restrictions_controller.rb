
class SponsorRestrictionsController < ApplicationController
  before_action :set_project
  before_action :authorize_admin_or_prof

  def create
    @sponsor_restriction = @project.sponsor_restrictions.build(sponsor_restriction_params)
    if @sponsor_restriction.save
      flash[:notice] = "Sponsor Restriction was successfully created"
      redirect_to edit_project_path(@project)
    else
      flash[:error] =  @sponsor_restriction.errors.full_messages.join(', ')
      redirect_to new_project_sponsor_restriction_path(@project)
    end
  end

  def edit
    @sponsor_restriction = @project.sponsor_restrictions.find(params[:id])
    set_restrictions
  end

  def new
    @sponsor_restriction = SponsorRestriction.new
    set_restrictions
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

  def set_restrictions
    @restrictions = {}
    @restrictions['gender'] = STUDENT_STATUS_CONSTANTS['gender']
    @restrictions['work_auth'] = STUDENT_STATUS_CONSTANTS['work_auth']
    @restrictions['contract_sign'] = STUDENT_STATUS_CONSTANTS['contract_sign']
    @restrictions['nationality'] = STUDENT_STATUS_CONSTANTS['nationality']

    @restrictions
  end
end

