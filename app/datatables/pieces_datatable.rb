class PiecesDatatable < AjaxDatatablesRails
  
  def initialize(view)
    @model_name = Piece
    @columns = ["pieces.id", "pieces.title", "composers.name", "pieces.created_at", "pieces.updated_at"]
    @searchable_columns = ["pieces.id", "pieces.title", "composers.name"]
    super(view)
  end
  
private
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

    def pieces
      @pieces ||= fetch_records
    end

    def get_raw_records
      Piece.joins(:composer)
    end
    
    def get_raw_record_count
      search_records(get_raw_records).count
    end
    
    # ==== Insert 'presenter'-like methods below if necessary
end
