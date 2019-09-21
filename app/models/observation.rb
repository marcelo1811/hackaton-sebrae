class Observation < ApplicationRecord
  belongs_to :establishment
  belongs_to :step
end
