class Role < ActiveRecord::Base

  # Association macros
  has_many :roles_users
  has_many :users, :through => :roles_users # For authorizations

end
