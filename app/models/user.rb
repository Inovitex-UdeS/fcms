class User < ActiveRecord::Base

  # Association macros
  has_many :payments
  has_many :registrations_users
  has_many :instruments, :through => :registrations_users

  has_and_belongs_to_many :registrations
  has_and_belongs_to_many :roles # For authorizations

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def has_role?(role_sym)
    if not role_sym .is_a? (:administrateur.class)
      role_sym = role_sym.parameterize.underscore.to_sym
    end
    roles.any? { |r| r.name.underscore.to_sym == role_sym }
  end

end
