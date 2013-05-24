class Payment < ActiveRecord::Base
  # association macros
  belongs_to :registrations, :users

end
