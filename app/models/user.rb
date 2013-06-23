class User < ActiveRecord::Base

  # Association macros
  has_many :payments
  has_many :roles_users
  has_many :registrations_users
  has_many :roles, :through => :roles_users
  has_many :instruments, :through => :registrations_users
  has_many :registrations, :through => :registrations_users

  belongs_to :contactinfo

  accepts_nested_attributes_for :contactinfo, :allow_destroy => true

  # Include default devise modules.
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :token_authenticatable, :confirmable, :lockable

  # Scopes
  scope :with_role, lambda{ |role| joins(:roles).where(:roles => {:name => role}) }

  # Validates
  validates :first_name, :presence => true
  validates :last_name, :presence => true
  validates :birthday, :presence => true

  # Class methods
  def self.participants
    User.with_role('Participant')
  end

  def self.teachers
    User.with_role('Professeur')
  end

  def self.juges
    User.with_role('Juges').where(confirmed: true)
  end

  def self.admins
    User.with_role('Administrateur').where(confirmed: true)
  end

  # Instance methods
  def has_role?(role_sym)
    roles.any? { |r| (r.name.to_s.capitalize == role_sym.to_s.capitalize) }
  end

end
