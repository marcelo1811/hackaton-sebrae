class Observation < ApplicationRecord
  belongs_to :establishment
  belongs_to :step, optional: true
end
