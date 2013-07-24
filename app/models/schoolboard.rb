class Schoolboard < ActiveRecord::Base

  validates :name, :presence => true, :length => { :maximum => 128}, :uniqueness => true
  # Association macros
  has_many :schools

end


