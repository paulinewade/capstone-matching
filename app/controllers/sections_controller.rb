# app/controllers/sections_controller.rb
class SectionsController < ApplicationController
  def new
    @section = Section.new
  end

  def create
    @section = Section.new(section_params)

    if @section.save
      flash[:notice] = 'Section added successfully'
      redirect_to new_section_path
    else
      flash[:error] = 'Error adding section'
      render :new
    end
  end

  private

  def section_params
    params.require(:section).permit(:name)
  end
end
