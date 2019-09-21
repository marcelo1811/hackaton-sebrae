class EstablishmentsController < ApplicationController
  before_action :set_establishment, only: [:show, :edit, :update]
  before_action :set_params, only: [:update]

  def index
    @establishments = Establishment.all
  end

  def new
    @establishment = Establishment.new
  end

  def create
    establishment = Establishment.create!
    establishment.fantasy_name = establishment_params[:fantasy_name]
    establishment.emails.create(email: establishment_params[:email])
    establishment.observations.create(content: establishment_params[:observation_content])
    establishment.whatsapps.create(number: establishment_params[:whatsapp])
    establishment.addresses.create(city: establishment_params[:city],
                                   neighborhood: establishment_params[:neighborhood],
                                   street: establishment_params[:street],
                                   number: establishment_params[:number]
                                  )
   establishment.save!
   redirect_to establishments_path
  end

  def edit
  end

  def update
    @establishment.fantasy_name = @fantasy_name if @establishment.fantasy_name != @fantasy_name
    @establishment.emails.create(email: @email) if @establishment.emails.last != @email
    @establishment.observations.create(content: @content) if @establishment.observations.last.content != @content
    @establishment.whatsapps.create(number: @whatsapp_number) if @establishment.whatsapps.last.number != @whatsapp_number
    @establishment.addresses.create(city: @address_city,
                                   neighborhood: @address_neighborhood,
                                   street: @address_street,
                                   number: @address_number
                                  )
    @establishment.save!
    redirect_to establishments_path
  end

  private

  def establishment_params
    params.require(:establishment).permit(:fantasy_name,
                                          :email,
                                          :observation_content,
                                          :whatsapp,
                                          :city,
                                          :neighborhood,
                                          :street,
                                          :number
                                         )
  end

  def set_establishment
    @establishment = Establishment.find(params[:id])
  end

  def set_params
    @fantasy_name = establishment_params[:fantasy_name]
    @email = establishment_params[:email]
    @content = establishment_params[:observation_content]
    @whatsapp_number = establishment_params[:whatsapp]
    @address_city = establishment_params[:city]
    @address_neighborhood = establishment_params[:neighborhood]
    @address_street = establishment_params[:street]
    @address_number = establishment_params[:number]
  end
end
