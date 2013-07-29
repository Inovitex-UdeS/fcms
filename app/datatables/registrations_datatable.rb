class RegistrationsDatatable < AjaxDatatablesRails
  
  def initialize(view)
    @model_name = Registration
    @columns = ["registrations.id", "categories.name", "instruments.name", "users.last_name", "registrations.age_max", "pieces.title", "composers.name", "users._last_name", "registrations.duration", "editions.year", "registrations.created_at", "registrations.updated_at"]
    @searchable_columns = ["registrations.id", "categories.name", "instruments.name", "users.last_name", "registrations.age_max", "pieces.title", "composers.name", "registrations.duration", "editions.year"]
    super(view)
  end
  
private

    def data
      registrations.map do |registration|
        [
          registration.id,
          registration.category.name,
          registration.print_instruments,
          registration.print_users,
          registration.age_max,
          registration.print_pieces,
          registration.print_composers,
          registration.teacher.last_name + ', ' + registration.teacher.first_name,
          registration.duration.to_s + ' min.',
          registration.edition.year,
          registration.created_at.strftime("%d/%m/%Y"),
          registration.updated_at.strftime("%d/%m/%Y")
        ]
      end
    end

    def registrations
      @registrations ||= fetch_records.order('categories.name ASC, instruments.name ASC, registrations.age_max ASC')
    end

    def get_raw_records
      Registration.joins(:edition).joins(:users).joins(:instruments).joins(:category).joins('LEFT JOIN performances ON performances.registration_id = registrations.id LEFT JOIN pieces ON pieces.id = performances.piece_id LEFT JOIN composers ON composers.id = pieces.composer_id').uniq
    end
    
    def get_raw_record_count
      search_records(get_raw_records).count
    end
    
    # ==== Insert 'presenter'-like methods below if necessary
end
