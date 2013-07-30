##
# Needed by ajax-dataTables gem. Will respond and send information to populate pieces dataTables
class PiecesDatatable < AjaxDatatablesRails
  ##
  # Constructor to get information needed to create subset of pieces table
  def initialize(view)
    @model_name = Piece
    @columns = ["pieces.id", "pieces.title", "composers.name", "pieces.created_at", "pieces.updated_at"]
    @searchable_columns = ["pieces.id", "pieces.title", "composers.name"]
    super(view)
  end
  
private
    ##
    # Get all the fields
    def data
      pieces.map do |piece|
        [
            piece.id,
            piece.title,
            piece.composer.name,
            piece.created_at.strftime("%d/%m/%Y"),
            piece.updated_at.strftime("%d/%m/%Y")
        ]
      end
    end

    ##
    # Post-process data
    def pieces
      @pieces ||= fetch_records
    end

    ##
    # Pre-process data
    def get_raw_records
      Piece.joins(:composer)
    end

    ##
    # Get the count of rows in the query
    def get_raw_record_count
      search_records(get_raw_records).count
    end
    
    # ==== Insert 'presenter'-like methods below if necessary
end
