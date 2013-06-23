class Performance < ActiveRecord::Base

  # Association macros
  belongs_to :piece
  belongs_to :registration

  accepts_nested_attributes_for :piece

end


