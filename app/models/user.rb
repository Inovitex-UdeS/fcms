class User < ActiveRecord::Base
  # Attributes
  attr_accessible :role, :email, :password, :password_confirmation, :remember_me

  # Association macros (has_many)
  has_many :payments
  has_and_belongs_to_many :role , :join_table => :userrole   # For authorizations


  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable



  def has_role?(role_sym)
    if not role_sym .is_a? (:administrateur.class)
      role_sym = role_sym.parameterize.underscore.to_sym
    end

    role.any? { |r| r.name.underscore.to_sym == role_sym }
  end
end
