class ProjectsController < ApplicationController
  def index
    @semesters = Project.pluck(:Semester).uniq
    @selected_semester = params[:semester]

    @projects = if @selected_semester.present?
      Project.where(Semester: @selected_semester)
    else
      Project.all
    end
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(project_params)
    respond_to do |format|
      if @project.save
        flash[:notice] = "Project was successfully created"
        format.html { redirect_to "/projects", notice: "Project was successfully created" }
      else
        format.html { render :new, status: :unprocessable_entity}
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    def project_params
      params.require(:project).permit(:Name, :Semester, :Sponsor, :Description, :Link)
    end
end