class User < ApplicationRecord
  belongs_to :organization
  has_many :story_points

  validates :email, :name, presence: true
  validates :email, uniqueness: true
end
