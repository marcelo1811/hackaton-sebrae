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
    filter_by_cpf_cnpj if @cpf_cnpj.present?
    @results_count = @establishments.length
    @establishments = @establishments.page(current_page)
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
    whatsapps = @establishment.whatsapps.order(:created_at) if @establishment.whatsapps.present?
    phones = @establishment.phones.order(:created_at) if @establishment.phones.present?
    address = @establishment.addresses.order(:created_at) if @establishment.addresses.present?
    email = @establishment.emails.order(:created_at) if @establishment.emails.present?

    @resources = []
    @resources << whatsapps
    @resources << phones
    @resources << address
    @resources << email
    @resources = @resources.flatten.sort_by(&:created_at).reverse
  end

  def edit
  end

  def update
    @establishment.fantasy_name = @fantasy_name if @establishment.fantasy_name != @fantasy_name
    @establishment.emails.create(email: @email) if @establishment.emails.last.email != @email
    @establishment.observations.create(content: @content) if (@establishment.observations.present? && @establishment.observations.order(:created_at).last.content != @content) || @establishment.observations.blank?
    @establishment.whatsapps.create(number: @whatsapp_number) if (@establishment.whatsapps.present? && @establishment.whatsapps.order(:created_at).last.number != @whatsapp_number) || @establishment.whatsapps.blank?
    @establishment.phones.create(number: @phone_number) if (@establishment.phones.present? && @establishment.phones.order(:created_at).last.number != @phone_number) || @establishment.phones.blank?
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
    FacebookService.run_places_graph
  end

  def search
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
                                          :file,
                                          :cpf_cnpj
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
    @cpf_cnpj = establishment_params[:cpf_cnpj]
  end

  def update_address?
    return true if @establishment.addresses.order(:created_at).blank?
    return true if @establishment.addresses.order(:created_at).last.city != @address_city
    return true if @establishment.addresses.order(:created_at).last.street != @address_street
    return true if @establishment.addresses.order(:created_at).last.neighborhood != @address_neighborhood
    return true if @establishment.addresses.order(:created_at).last.number != @address_number.to_i
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

  def filter_by_cpf_cnpj
    @establishments = @establishments.where('establishments.cpf_cnpj ILIKE ?', "%#{@cpf_cnpj}%").group(:id)
  end
end
