class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]

  def password_required?
    false
  end

  def self.from_omniauth(auth, user_type)
    if auth.is_a?(OmniAuth::AuthHash)
      user = where(email: auth.info.email).first_or_initialize do |u|
        u.user_id = u.id
        u.email = auth.info.email
        u.password = Devise.friendly_token[0, 20]
        u.first_name = auth.info.first_name # assuming the user model has a name
        u.last_name = auth.info.last_name # assuming the user model has an image
      end

      # Set the user's role to "Student" for new records
      user.role ||= user_type # This sets the role to "Student" only if it's not already set

      # If you are using confirmable and the provider(s) you use validate emails,
      # uncomment the line below to skip the confirmation emails.
      # user.skip_confirmation!

      user.save if user.new_record? # Save the new record

      user
    else
      # Handle the case where auth is not an AuthHash, e.g., :invalid_credentials
      # You can raise an error, log the issue, or return nil, depending on your application's requirements.
      return nil
    end
  end

    # Fields from the table

    validates :email, presence: true
    validates :first_name, presence: true
    validates :last_name, presence: true
    validates :role, presence: true
    validates :user_id, presence: true
end
