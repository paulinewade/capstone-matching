class ProfregistrationController < ApplicationController
  def index
  end
  
  def create
    # Extract form parameters
    email = params[:email]
    first_name = params[:first_name]
    last_name = params[:last_name]

    if email.end_with?("tamu.edu")
      existing_prof = User.find_by(email: email)

      if existing_prof
        flash[:error] = "You are already registered using this email. Please wait for the admin to approve your registration or login if you are already approved."
      else
        new_user = User.new(email: email, first_name: first_name, last_name: last_name, role: 'professor')

        if new_user.save
          # Create a corresponding Professor record
          user_id = new_user.user_id
          new_professor = Professor.new(professor_id: user_id, verified: false, admin: false)
          if new_professor.save
            flash[:success] = "Registration Successful! Please wait for admin approval."
          else
            new_user.destroy
            flash[:error] = "Professor can't be saved"
          end
        else
          flash[:error] = "User can't be saved"
        end
      end
    else
      flash[:error] = "Not a valid tamu.edu email address."
    end
    render :index
  end
end

