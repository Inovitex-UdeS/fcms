class DeviseCreateUsers < ActiveRecord::Migration
  def change
    ## Database authenticatable
    add_column :USER, :email, :string, :null => false, :default => ""
    add_column :USER, :encrypted_password, :string, :null => false, :default => ""

    ## Recoverable
    add_column :USER, :reset_password_token, :string
    add_column :USER, :reset_password_sent_at, :datetime

    ## Rememberable
    add_column :USER, :remember_created_at, :datetime

    ## Trackable
    add_column :USER, :sign_in_count, :integer, :default => 0
    add_column :USER, :current_sign_in_at, :datetime
    add_column :USER, :last_sign_in_at, :datetime
    add_column :USER, :current_sign_in_ip, :string
    add_column :USER, :last_sign_in_ip, :string

    ## Confirmable
    # t.string   :confirmation_token
    # t.datetime :confirmed_at
    # t.datetime :confirmation_sent_at
    # t.string   :unconfirmed_email # Only if using reconfirmable

    ## Lockable
    # t.integer  :failed_attempts, :default => 0 # Only if lock strategy is :failed_attempts
    # t.string   :unlock_token # Only if unlock strategy is :email or :both
    # t.datetime :locked_at

    ## Token authenticatable
    # t.string :authentication_toke

    add_column :USER, :created_at, :datetime
    add_column :USER, :updated_at, :datetime

    add_index :USER, :email,                :unique => true
    add_index :USER, :reset_password_token, :unique => true
    # add_index :users, :confirmation_token,   :unique => true
    # add_index :users, :unlock_token,         :unique => true
    # add_index :users, :authentication_token, :unique => true
  end
end
