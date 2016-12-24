class Sprint < ApplicationRecord
  belongs_to :project
  has_many :stories
end
