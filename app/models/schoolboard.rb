class Schoolboard < ActiveRecord::Base
  attr_accessible :name

  has_many :schools
end
