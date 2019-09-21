module ApplicationHelper
  def establishment_fantasy_name(establishment)
    establishment.fantasy_name rescue ''
  end

  def establishment_address_street(establishment)
    establishment.addresses.last.street rescue ''
  end

  def establishment_address_number(establishment)
    establishment.addresses.last.number rescue ''
  end

  def establishment_address_neighborhood(establishment)
    establishment.addresses.last.neighborhood rescue ''
  end

  def establishment_address_city(establishment)
    establishment.addresses.last.city rescue ''
  end

  def establishment_phone_number(establishment)
    establishment.phones.last.number rescue ''
  end

  def establishment_email(establishment)
    establishment.emails.last.email
  end

  def establishment_whatsapp(establishment)
    establishment.whatsapps.last.number
  end
end
