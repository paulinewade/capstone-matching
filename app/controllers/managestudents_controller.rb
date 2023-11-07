class ManagestudentsController < ApplicationController
    def index
      @students = User.includes(:student).where.not(students: { student_id: nil })
    end
end