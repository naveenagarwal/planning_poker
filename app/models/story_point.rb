class StoryPoint < ApplicationRecord
  belongs_to :user
  belongs_to :story
  belongs_to :sprint
end
