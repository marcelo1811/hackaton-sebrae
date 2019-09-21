class Establishment < ApplicationRecord
  attr_accessor :whatsapp
  attr_accessor :observation
  attr_accessor :phone
  attr_accessor :email
  attr_accessor :city
  attr_accessor :neightborhood
  attr_accessor :street
  attr_accessor :number

  has_many :whatsapps
  has_many :observations
  has_many :phone
  has_many :addresses
  has_many :emails
end
