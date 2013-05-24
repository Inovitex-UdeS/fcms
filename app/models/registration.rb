class Registration < ActiveRecord::Base

  attr_accessible :id, :duration

  # association macros
  has_many :performances

  belongs_to :category
  belongs_to :edition

  belongs_to :owner, :class_name => 'User', :foreign_key => "user_owner_id"
  belongs_to :teacher,:class_name => 'User', :foreign_key => "user_teacher_id"


  has_and_belongs_to_many :instruments , :join_table => :registrations_users
  has_and_belongs_to_many :users , :join_table => :registrations_users

  belongs_to :school

  # and validation macros
  #validates :id, presence: true
  #validates :username, presence: true
  #validates :username, uniqueness: { case_sensitive: false }
  #validates :username, format: { with: /\A[A-Za-z][A-Za-z0-9._-]{2,19}\z/ }
  #validates :password, format: { with: /\A\S{8,128}\z/, allow_nil: true}

  # next we have callbacks
  #before_save :cook
  #before_save :update_username_lower

  # other macros (like devise's) should be placed after the callbacks

end
