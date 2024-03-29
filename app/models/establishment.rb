class Establishment < ApplicationRecord
  # kaminari
  paginates_per 15

  attr_accessor :whatsapp
  attr_accessor :observation_content
  attr_accessor :step
  attr_accessor :phone
  attr_accessor :email
  attr_accessor :city
  attr_accessor :neighborhood
  attr_accessor :street
  attr_accessor :address_number
  attr_accessor :file

  has_many :whatsapps
  has_many :observations
  has_many :phones
  has_many :addresses
  has_many :emails
end
