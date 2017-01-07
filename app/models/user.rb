class User < ApplicationRecord
  belongs_to :organization
  has_many :story_points
end
