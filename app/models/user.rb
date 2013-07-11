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

  def self.accompanists
    User.with_role('Accompagnateur')
  end

  def self.teachers
    User.with_role('Professeur')
  end

  def self.juges
    User.joins(:roles).where(:roles_users => {:confirmed => true}, :roles => {:name => 'Juge'})
  end

  def self.unconfirmed_juges
    User.joins(:roles).where(:roles_users => {:confirmed => false}, :roles => {:name => 'Juge'})
  end

  def self.admins
    User.with_role('Administrateur')
  end

  # Instance methods
  def has_role?(role_sym)
    roles.any? { |r| (r.name.to_s.capitalize == role_sym.to_s.capitalize) }
  end

  def is_admin?
    return self.has_role?('Administrateur')
  end

  def name
    self.first_name + " " + self.last_name
  end
end
