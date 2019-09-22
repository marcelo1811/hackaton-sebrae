class EstablishmentsController < ApplicationController
  before_action :set_establishment, only: [:show, :edit, :update]
  before_action :set_params, only: [:update, :create, :index]

  def index
    current_page = params[:page].present? ? params[:page].to_i : 1
    @pages = current_page.upto(current_page + 10).to_a

    @establishments = Establishment.all
    @total_count = @establishments.length
    filter_by_fantasy_name if @fantasy_name.present?
    filter_by_neighborhood if @address_neighborhood.present?
    filter_by_email if @email.present?
    filter_by_city if @address_city.present?
    @results_count = @establishments.length
    @establishments = @establishments.page(current_page)
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

  def import_csv
    file = establishment_params[:file]
    sheet = Roo::Spreadsheet.open(file.path)
    sheet = sheet.parse(headers: true, clean: true)
    header = sheet.shift
    sheet.each do |row|
      next if Establishment.find_by(cpf_cnpj: row['CPF_CNPJ']).present?
      establishment = Establishment.create!
      establishment.fantasy_name = row['Nome Fantasia']
      establishment.cpf_cnpj = row['CPF_CNPJ']
      establishment.emails.create(email: row['Email'])
      establishment.observations.create(content: 'Importado da planilha')
      establishment.whatsapps.create(number: row['Celular'])
      establishment.phones.create(number: row['Telefone'])
      establishment.addresses.create(city: row['Cidade'],
                                     neighborhood: row['Bairro'],
                                     street: row['Endereço'],
                                     number: row['Número'],
                                     latitude: row['Latitude'],
                                     longitude: row['Longitude'],
                                     state: row['UF'],
                                     zip: row['CEP']
                                    )
      establishment.save!
    end
    redirect_to establishments_path
  end

  def facebook_script
    fields = ['id','checkins','engagement','is_verified','link','location','name','overall_star_rating','phone','rating_count','single_line_address','website']
    fields = fields.join(',')
    token = "EAAFfAyix3dUBAFZCsLRYWF5qQVnbHv7kDJ5ZAHSDokxGDncDI59gb8raDQ1iVZCtmPZA4y6SZC3JnV4w0uWFNrmzmoWDusRzHZB4MZBDAkAnfG1yfjqyzxNMuQOAWJhyZCaDYHGbUUIfRW5SKRrcZBjQAHXTwZAPYcx3xIZB3r73wkTLpWrHdjgyTL0mcbTsDoB7aFJeQQN2ypkzQZDZD"

    url = "https://graph.facebook.com/v3.2/search?type=place&center=-25.4234855,-49.3207829&distance=1500&q=pizza&fields=#{fields}&limit=2&access_token=#{token}"
    response = HTTParty.get(url)
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
                                          :step,
                                          :file
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
    @establishments = @establishments.where('establishments.fantasy_name ILIKE ?', "%#{@fantasy_name}%")
  end

  def filter_by_neighborhood
    @establishments = @establishments.joins(:addresses).where('addresses.neighborhood ILIKE ?', "%#{@address_neighborhood}%").group(:id)
  end

  def filter_by_email
    @establishments = @establishments.joins(:emails).where('emails.email ILIKE ?', "%#{@email}%").group(:id)
  end

  def filter_by_city
    @establishments = @establishments.joins(:addresses).where('addresses.city ILIKE ?', "%#{@address_city}%").group(:id)
  end
end
