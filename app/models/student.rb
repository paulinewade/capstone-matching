class Student < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]

  def self.from_omniauth(auth)
    if auth.is_a?(OmniAuth::AuthHash)
      where(provider: auth.provider, uid: auth.uid).first_or_create do |student|
        student.email = auth.info.email
        student.password = Devise.friendly_token[0, 20]
        student.full_name = auth.info.name # assuming the student model has a name
        student.avatar_url = auth.info.image # assuming the student model has an image
        # If you are using confirmable and the provider(s) you use validate emails,
        # uncomment the line below to skip the confirmation emails.
        # student.skip_confirmation!
      end
    else
      # Handle the case where auth is not an AuthHash, e.g., :invalid_credentials
      # You can raise an error, log the issue, or return nil, depending on your application's requirements.
      return nil
    end
  end
end
