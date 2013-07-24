class Role < ActiveRecord::Base
  validates :name, :presence => true, :length => { :maximum => 128}, :uniqueness => true

  # Association macros
  has_many :roles_users
  has_many :users, :through => :roles_users # For authorizations

end
