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
    @semesters = generate_semesters
    @project = Project.new
  end

  def create
    @semesters = generate_semesters
    @project = Project.new(project_params)
    puts("Semester name" , @project.Semester)
    respond_to do |format|
      if @project.save
        flash[:notice] = "Project was successfully created"
        format.html { redirect_to "/projects", notice: "Project was successfully created" }
      else
        flash[:error] =  @project.errors.full_messages.join(', ')
        format.html { render :new, status: :unprocessable_entity}
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    def project_params
      params.require(:project).permit(:Name, :Semester, :Sponsor, :Description, :Link)
    end

    def generate_semesters
      current_year = Time.now.year
      semesters = []

      (0..2).each do |year_offset|
        year = current_year + year_offset
        semesters << "Spring #{year}"
        semesters << "Summer #{year}"
        semesters << "Fall #{year}"
      end

      semesters
    end
end