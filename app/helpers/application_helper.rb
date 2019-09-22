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

  def object_name(object)
    object.class.name
  end

  def object_from(object)
    className = object.class.name

    if className == 'Whatsapp'
      object.establishment.whatsapps.order(:created_at).where('whatsapps.created_at < ?', object.created_at).last.number rescue '-'
    elsif className == 'Phone'
      object.establishment.phones.order(:created_at).where('phones.created_at < ?', object.created_at).last.number rescue '-'
    elsif className == 'Address'
      address = object.establishment.addresses.order(:created_at).where('addresses.created_at < ?', object.created_at).last rescue return
      beauty_address(address)
    elsif className == 'Email'
      object.establishment.emails.order(:created_at).where('emails.created_at < ?', object.created_at).last.email rescue return
    elsif className == 'Observation'
      return
    end
  end

  def object_to(object)
    className = object.class.name

    if className == 'Whatsapp'
      object.number rescue '-'
    elsif className == 'Phone'
      object.number rescue '-'
    elsif className == 'Address'
      beauty_address(object)
    elsif className == 'Email'
      object.email
    elsif className == 'Observation'
      '-'
    end
  end

  def beauty_address(address)
    return '-' if address.blank?
    "#{address.street}, #{address.number} - #{address.city} - #{address.state}"
  end

  def beaty_date(date)
    date.strftime("%d/%m/%y - %H:%M")
  end
end
