##
# Needed by ajax-dataTables gem. Will respond and send information to populate composers dataTables
class ComposersDatatable < AjaxDatatablesRails

  ##
  # Constructor to get information needed to create subset of composers table
  def initialize(view)
    @model_name = Composer
    @columns = ["composers.id", "composers.name", "composers.created_at", "composers.updated_at"]
    @searchable_columns =["composers.id", "composers.name"]
    super(view)
  end
  
private
    ##
    # Get all the fields
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

    ##
    # Post-process data
    def composers
      @composers ||= fetch_records
    end

    ##
    # Pre-process data
    def get_raw_records
      Composer
    end

    ##
    # Get the count of rows in the query
    def get_raw_record_count
      search_records(get_raw_records).count
    end
    
    # ==== Insert 'presenter'-like methods below if necessary
end
