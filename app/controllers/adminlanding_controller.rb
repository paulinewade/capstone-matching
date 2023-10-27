class AdminlandingController < ApplicationController
    def index
    end

    def lock_unlock_form
      @students = Student.all
    end

    def lock_unlock
        @student = Student.find_by(uin: params[:uin])

        if @student.update(student_params)
            flash[:notice] = "Student lock state updated successfully"
        else
            flash[:alert] = "Error updating student lock state"
        end

        redirect_to lock_unlock_form_path
    end

    before_action :check_form_locked_param, only: :lock_unlock_all_students

    def lock_unlock_all_students
        if Student.update_all(form_locked: params[:form_locked])
            flash[:notice] = "All students lock state updated successfully"
        else
            flash[:alert] = "Error updating all students lock state"
        end

        redirect_to lock_unlock_form_path
    end

    private

    def check_form_locked_param
        params[:form_locked] = params[:form_locked] == "on"
    end

    private

    def student_params
        params.require(:student).permit(:form_locked)
    end
end
