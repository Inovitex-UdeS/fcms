##
# Needed by ajax-dataTables gem. Will respond and send information to populate users dataTables
class UsersDatatable < AjaxDatatablesRails

  ##
  # Constructor to get information needed to create subset of users table
  def initialize(view)
    @model_name = User
    @columns = ["users.id", "users.last_name", "users.first_name", "users.email", "users.confirmed_at", "users.created_at", "users.updated_at"]
    @searchable_columns = ["users.id", "users.first_name", "users.last_name", "users.email"]
    super(view)
  end
  
private
    ##
    # Get all the fields
    def data
      users.map do |user|
        [
          user.id,
          user.last_name,
          user.first_name,
          user.email,
          user.confirmed_at ? "oui": "non",
          user.created_at.strftime("%d/%m/%Y"),
          user.updated_at.strftime("%d/%m/%Y")
        ]
      end
    end

    ##
    # Post-process data
    def users
      @users ||= fetch_records
    end

    ##
    # Pre-process data
    def get_raw_records
      User
    end

    ##
    # Get the count of rows in the query
    def get_raw_record_count
      search_records(get_raw_records).count
    end
    
    # ==== Insert 'presenter'-like methods below if necessary
end
