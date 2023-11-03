class Professor < ApplicationRecord
  before_validation :set_defaults

  self.primary_key = 'professor_id'
  belongs_to :user, foreign_key: 'professor_id'
  validates :verified, presence: true
  validates :admin, presence: true

  private

  def set_defaults
    self.verified = false
    self.admin = false
  end
end

