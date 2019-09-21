class Establishment < ApplicationRecord
  has_many :whatsapps
  has_many :observations
  has_many :phone
  has_many :addresses
  has_many :emails
end
