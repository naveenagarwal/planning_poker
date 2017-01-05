class Story < ApplicationRecord
  belongs_to :sprint
  has_many :story_points
end
