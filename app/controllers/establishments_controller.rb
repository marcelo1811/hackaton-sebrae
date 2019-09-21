class EstablishmentsController < ApplicationController
  before_action :set_establishment, only: [:show, :edit, :update]
  before_action :set_params, only: [:update, :create, :index]

  def index
    @establishments = Establishment.all
    filter_by_fantasy_name if @fantasy_name.present?
    filter_by_neighborhood if @address_neighborhood.present?
    filter_by_email if @email.present?
    filter_by_city if @address_city.present?
    # filter_by_step
  end

  def new
    @establishment = Establishment.new
  end

  def create
    establishment = Establishment.create!
    establishment.fantasy_name = @fantasy_name
    establishment.emails.create(email: @email)
    establishment.observations.create(content: @content)
    establishment.whatsapps.create(number: @whatsapp_number)
    establishment.phones.create(number: @phone_number)
    establishment.addresses.create(city: @address_city,
                                   neighborhood: @address_neighborhood,
                                   street: @address_street,
                                   number: @address_number
                                  )
   establishment.save!
   redirect_to establishments_path
  end

  def show
  end

  def edit
  end

  def update
    @establishment.fantasy_name = @fantasy_name if @establishment.fantasy_name != @fantasy_name
    @establishment.emails.create(email: @email) if @establishment.emails.last.email != @email
    @establishment.observations.create(content: @content) if (@establishment.observations.present? && @establishment.observations.last.content != @content) || @establishment.observations.blank?
    @establishment.whatsapps.create(number: @whatsapp_number) if (@establishment.whatsapps.present? && @establishment.whatsapps.last.number != @whatsapp_number) || @establishment.whatsapps.blank?
    @establishment.phones.create(number: @phone_number) if (@establishment.phones.present? && @establishment.phones.last.number != @phone_number) || @establishment.phones.blank?
    @establishment.addresses.create(city: @address_city,
                                   neighborhood: @address_neighborhood,
                                   street: @address_street,
                                   number: @address_number
                                  ) if update_address?
    @establishment.save!
    redirect_to establishments_path
  end

  private

  def establishment_params
    return if params[:establishment].blank?
    params.require(:establishment).permit(:fantasy_name,
                                          :email,
                                          :observation_content,
                                          :phone,
                                          :whatsapp,
                                          :city,
                                          :neighborhood,
                                          :street,
                                          :address_number,
                                          :step
                                         )
  end

  def set_establishment
    @establishment = Establishment.find(params[:id])
  end

  def set_params
    return if params[:establishment].blank?
    @fantasy_name = establishment_params[:fantasy_name]
    @email = establishment_params[:email]
    @content = establishment_params[:observation_content]
    @whatsapp_number = establishment_params[:whatsapp]
    @phone_number = establishment_params[:phone]
    @address_city = establishment_params[:city]
    @address_neighborhood = establishment_params[:neighborhood]
    @address_street = establishment_params[:street]
    @address_number = establishment_params[:address_number]
  end

  def update_address?
    return true if @establishment.addresses.blank?
    return true if @establishment.addresses.last.city != @address_city
    return true if @establishment.addresses.last.street != @address_street
    return true if @establishment.addresses.last.neighborhood != @address_neighborhood
    return true if @establishment.addresses.last.number != @addresses_number
    false
  end

  def filter_by_fantasy_name
    @establishments = @establishments.where('establishments.fantasy_name LIKE ?', "%#{@fantasy_name}%")
  end

  def filter_by_neighborhood
    @establishments = @establishments.joins(:addresses).where('addresses.neighborhood LIKE ?', "%#{@address_neighborhood}%").group(:id)
  end

  def filter_by_email
    @establishments = @establishments.joins(:emails).where('emails.email LIKE ?', "%#{@email}%").group(:id)
  end

  def filter_by_city
    @establishments = @establishments.joins(:addresses).where('addresses.city LIKE ?', "%#{@address_city}%").group(:id)
  end
end
