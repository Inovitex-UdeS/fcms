class Performance < ActiveRecord::Base

  # Association macros
  belongs_to :piece
  belongs_to :registration

end


