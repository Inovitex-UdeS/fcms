class ComposersDatatable < AjaxDatatablesRails
  
  def initialize(view)
    @model_name = Composer
    @columns = ["composers.id", "composers.name", "composers.created_at", "composers.updated_at"]
    @searchable_columns =["composers.id", "composers.name"]
    super(view)
  end
  
private
    def data
      composers.map do |composer|
        [
            composer.id,
            composer.name,
            composer.created_at.strftime("%d/%m/%Y"),
            composer.updated_at.strftime("%d/%m/%Y")
        ]
      end
    end

    def composers
      @composers ||= fetch_records
    end

    def get_raw_records
      Composer
    end
    
    def get_raw_record_count
      search_records(get_raw_records).count
    end
    
    # ==== Insert 'presenter'-like methods below if necessary
end
