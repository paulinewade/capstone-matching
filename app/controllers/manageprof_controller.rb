class ManageprofController < ApplicationController
    def index
      @professors = User.includes(:professor => :courses).where.not(professors: { professor_id: nil })
    end
    
    def save_change
        if params[:admin_approved] || params[:admin]
            update_values
        end

        if params[:delete_professor_emails]
            delete_professor
        end

        flash[:success] = "Changes Saved."
        @professors = User.includes(:professor => :courses).where.not(professors: { professor_id: nil })
        render :index
    end

    def delete_professor
        emails = params[:delete_professor_emails]
      
        if emails.present?
          emails.each do |email|
            professor = User.find_by(email: email)
      
            if professor
              professor.destroy
            end
          end
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

        if admin == true
            user = User.new( email: email, first_name: first_name, last_name: last_name, role: 'admin')
        else
            user = User.new( email: email, first_name: first_name, last_name: last_name, role: 'professor')
        end

        if email.end_with?("tamu.edu")
            existing_prof = User.find_by(email: email)
            if existing_prof
                flash[:error] = "Professor already registered."
            else
                if user.save
                    professor = Professor.create(professor_id: user.user_id, verified: true, admin: admin)
                    flash[:success] = "Professor added."
                end
            end
        else
            flash[:error] = "Not a valid tamu.edu email address."
        end
        @professors = User.includes(:professor => :courses).where.not(professors: { professor_id: nil })
        render :index
    end

    def update_values
        verified_params = params[:verified]
        admin_params = params[:admin]
        delete_professor_emails = params[:delete_professor_emails]

        # Iterate through verified parameters
        verified_params.each do |email, value|
            user = User.find_by(email: email)
            professor = user&.professor

            if professor
                professor.update(verified: value == "Yes")
            end
        end

        admin_params.each do |email, value|
            user = User.find_by(email: email)
            professor = user&.professor

            if professor
                professor.update(admin: value == "Yes")
            end
        end
    end
end
  
  