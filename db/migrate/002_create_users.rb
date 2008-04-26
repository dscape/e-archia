# ============================================================================
# e-archia: create_users migration                                         002
# author: nunojobpinto[at]gmail[dot]com                                      
# ============================================================================
class CreateUsers < ActiveRecord::Migration
  # ==========================================================================
  # version UP
  # ==========================================================================
  def self.up
    # ========================================================================
    # create tables
    # ========================================================================
    create_table :users do |t|
      t.string :username,       :limit => 64,   :null => false
      t.string :password_hash,  :limit => 64,   :null => false
      t.string :password_salt,  :limit => 8,    :null => false
      t.string :first_name,     :limit => 64,   :null => false
      t.string :last_name,      :limit => 64
      t.string :email,          :limit => 128,  :null => false
      t.string :profile,        :limit => 2048
      t.string :homepage,       :limit => 128
      t.string :openid,         :limit => 128
      t.boolean :enabled,       :default => true, :null => false
      t.datetime :last_login_at
      t.timestamps
    end
    # ========================================================================
    #  add foreign key to other tables
    # ========================================================================
    add_column :stories, :user_id, :integer, :null => false, :default => 1

    # ========================================================================
    #  make indexes
    # ========================================================================
    add_index :users, :username
    add_index :users, :email

    # ========================================================================
    # create some data
    # ========================================================================
    u_root = User.new
    u_root.username      = 'root'
    u_root.password      = 'aaaaaaaa'
    u_root.password_confirmation = 'aaaaaaaa'
    u_root.first_name    = 'e-archia'
    u_root.last_name     = 'admin'
    u_root.homepage      = 'http://www.e-archia.net'
    u_root.openid        = 'http://www.e-archia.net'
    u_root.email         = 'admin@e-achia.net'
    u_root.profile       = "e-archia default admin profile"
    u_root.last_login_at = Time.now
    u_root.before_save
    u_root.save

  end

  # ==========================================================================
  # version DOWN
  # ==========================================================================
  def self.down
    # ========================================================================
    # drop tables
    # ========================================================================
    drop_table :users
    # ========================================================================
    #  remove foreign key from other tables
    # ========================================================================
    remove_column :stories, :user_id
  end
end