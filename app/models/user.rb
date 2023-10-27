class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]

  def self.from_omniauth(auth, user_type)
    if auth.is_a?(OmniAuth::AuthHash)
      user = where(email: auth.info.email).first_or_initialize do |u|
        u.email = auth.info.email
        u.password = Devise.friendly_token[0, 20]
        u.full_name = auth.info.name # assuming the user model has a name
        u.avatar_url = auth.info.image # assuming the user model has an image
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
  has_many :professor_preferences, foreign_key: 'professor_id'
  has_many :preferred_projects, through: :professor_preferences, source: :project
end
