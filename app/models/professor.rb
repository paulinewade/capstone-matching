class Professor < ApplicationRecord
    belongs_to :user
    attribute :admin, :boolean
    attribute :verified, :boolean
    attribute :user_id, :integer
end
