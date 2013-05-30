class User < ActiveRecord::Base

  # Association macros
  has_many :payments
  has_many :roles_users
  has_many :registrations_users
  has_many :roles, :through => :roles_users
  has_many :instruments, :through => :registrations_users
  has_many :registrations, :through => :registrations_users

  belongs_to :contactinfo

  accepts_nested_attributes_for :contactinfo

  # Include default devise modules.
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :token_authenticatable, :confirmable, :lockable

  def has_role?(role_sym)
    if not role_sym .is_a? (:administrateur.class)
      role_sym = role_sym.parameterize.underscore.to_sym
    end
    roles.any? { |r| r.name.underscore.to_sym == role_sym }
  end

  validates :first_name, :presence => true
  validates :last_name, :presence => true
  validates :birthday, :presence => true
end
