class Contactinfo < ActiveRecord::Base

  # Association macros
  has_many :users
  has_many :schools

  belongs_to :city

end
