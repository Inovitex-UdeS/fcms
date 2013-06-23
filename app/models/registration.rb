class Registration < ActiveRecord::Base

  # Associations marcos
  has_many :performances
  has_many :registrations_users
  has_many :instruments, :through => :registrations_users
  has_many :users, :through => :registrations_users

  belongs_to :category
  belongs_to :edition
  belongs_to :owner, :class_name => 'User', :foreign_key => 'user_owner_id'
  belongs_to :teacher,:class_name => 'User', :foreign_key => 'user_teacher_id'
  belongs_to :school

 # Nested attributes
  accepts_nested_attributes_for :performances, allow_destroy: true
  accepts_nested_attributes_for :users, allow_destroy: true
  accepts_nested_attributes_for :instruments, allow_destroy: true
  accepts_nested_attributes_for :registrations_users, allow_destroy: true

end
