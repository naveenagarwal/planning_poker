class StoryPointSerializer < ActiveModel::Serializer
  attributes :id, :estimated_points
  belongs_to :user
  belongs_to :story
  belongs_to :sprint
end
