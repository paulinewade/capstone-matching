class ProfregistrationController < ApplicationController
  def index
  end

  def create
    # Extract form parameters
    email = params[:email]
    first_name = params[:first_name]
    last_name = params[:last_name]

    if email.end_with?("tamu.edu")
      existing_prof = Professor.find_by(email: email)

      if existing_prof
        flash[:error] = "You are already registered using this email. Please wait for the admin to approve your registration or login if you are already approved."
      else
        new_professor = Professor.new(email: email, first_name: first_name, last_name: last_name)
        if new_professor.save
          flash[:success] = "Registration Successful! Please wait for admin approval."
        end
      end
    else
      flash[:error] = "Not a valid tamu.edu email address."
    end
    redirect_to profregistration_path and return
  end
end
