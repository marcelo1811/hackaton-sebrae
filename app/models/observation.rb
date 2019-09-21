class Observation < ApplicationRecord
  belongs_to :establishment_id
  belongs_to :step_id
end
