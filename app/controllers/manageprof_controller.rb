class ManageprofController < ApplicationController
    def index
        @professors = User.where(role: 'professor')
        @professor_data = []
        
        @professors.each do |professor|
            prof_bools = Professor.find_by(id: professor.user_id)
            admin = prof_bools.admin
            verified = prof_bools.verified
            prof_courses = Course.where(professor_id: professor.id)
            courses = prof_courses.map { |course| "#{course.course_id}-#{course.section_number}-#{course.semester}" }.join(", ")
            professor_info = {
                id: professor.id,
                email: professor.email,
                first_name: professor.first_name,
                last_name: professor.last_name,
                courses: courses,
                admin: admin,
                admin_approved: verified
            }
            @professor_data << professor_info
        end
    end
    
    def save_change
        if params[:admin_approved] || params[:admin]
            update_values
        end

        if params[:delete_professor_emails]
            delete_professor
        end
        
        flash[:success] = "Changes saved."
        redirect_to manageprof_path and return
    end

    def delete_professor
        emails = params[:delete_professor_emails]
      
        if emails.present?
          emails.each do |email|
            user = User.find_by(email: email)
            professor = Professor.find_by(user_id: user.user_id)
            if user && professor
              courses = Course.where(professor_id: professor.user_id)
              courses.each do |course|
                course.update(professor_id: nil)
              end
              professor.destroy
              user.destroy
            end
          end
      
          flash[:success] = "Successfully deleted selected professors."
        end
    end
      

    def add_professor
        email = params[:email]
        first_name = params[:first_name]
        last_name = params[:last_name]
        if params[:admin] == 'on'
            admin = true
        else
            admin = false
        end
        if email.end_with?("tamu.edu")
            existing_prof = User.find_by(email: email)
    
            if existing_prof
                flash[:error] = "Professor already registered."
            else
                max_user_id = User.maximum(:user_id)
                next_user_id = max_user_id.to_i + 1
                prof_user = User.new(email: email, first_name: first_name, last_name: last_name, role: "professor", user_id: next_user_id)
                if prof_user.save
                    prof_user.update(id: prof_user.user_id)
                    professor_info = Professor.new(admin: false, verified: true, user_id: prof_user.id)
                    if professor_info.save 
                        flash[:success] = "Professor added."
                    else
                        flash[:error] = "Issue with saving professor."
                    end
                else
                    flash[:error] = "Could not save user."
                end
            end
        else
            flash[:error] = "Not a valid tamu.edu email address."
        end
        redirect_to manageprof_path and return
    end

    def update_values
        params[:admin_approved].each do |email, value|
            user = User.find_by(email: email)
            professor = Professor.find_by(user_id: user.user_id)
      
            if professor
              professor.update(verified: value == 'Yes')
            end
          end
      
        params[:admin].each do |email, value|
            user = User.find_by(email: email)
            professor = Professor.find_by(user_id: user.user_id)
      
            if professor
              professor.update(admin: value == 'Yes')
            end
        end
    end

end
  
  