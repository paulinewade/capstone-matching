class ManageprofController < ApplicationController
    def index
      @professors = Professor.all
    end
    
    def save_change
        if params[:admin_approved] || params[:admin]
            update_values
        end

        if params[:delete_professor_emails]
            delete_professor
        end
        
        flash[:success] = "Changes saved."
        @professors = Professor.all
        render :index
    end

    def delete_professor
        emails = params[:delete_professor_emails]
      
        if emails.present?
          emails.each do |email|
            professor = Professor.find_by(email: email)
      
            if professor
              professor.destroy
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
        professor = Professor.new( email: email,
                                   first_name: first_name,
                                   last_name: last_name,
                                   admin_approved: true,
                                   admin: admin )
        if email.end_with?("tamu.edu")
            existing_prof = Professor.find_by(email: email)
    
            if existing_prof
                flash[:error] = "Professor already registered."
            else
                if professor.save
                    flash[:success] = "Professor added."
                end
            end
        else
            flash[:error] = "Not a valid tamu.edu email address."
        end
        @professors = Professor.all
        render :index
    end

    def update_values
        params[:admin_approved].each do |email, value|
            professor = Professor.find_by(email: email)
      
            if professor
              professor.update(admin_approved: value == 'Yes')
            end
          end
      
        params[:admin].each do |email, value|
            professor = Professor.find_by(email: email)
      
            if professor
              professor.update(admin: value == 'Yes')
            end
        end
    end

end
  
  