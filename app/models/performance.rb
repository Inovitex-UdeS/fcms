class Performance < ActiveRecord::Base

  # Association macros
  belongs_to :piece
  belongs_to :registration

  attr_accessible :piece_id, :registration_id

end


