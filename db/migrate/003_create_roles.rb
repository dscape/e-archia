# ============================================================================
# e-archia: create_roles migration                                         003
# author: nunojobpinto[at]gmail[dot]com                                      
# ============================================================================
class CreateRoles < ActiveRecord::Migration
  # ==========================================================================
  # version UP
  # ==========================================================================
  def self.up
    # ========================================================================
    # create tables
    # ========================================================================
    create_table :roles_users, :id => false do |t|
      t.integer :role_id
      t.integer :user_id
      t.timestamps
    end

    create_table :roles do |t|
      t.string :name
      t.timestamps
    end

    create_table :rights_roles, :id => false do |t|
      t.integer :right_id
      t.integer :role_id
      t.timestamps
    end

    create_table :rights do |t|
      t.string :name
      t.string :controller
      t.string :action
      t.timestamps
    end

    # ========================================================================
    # create some data
    # ========================================================================

    #-------------------------------------------------------------------------
    # roles
    #-------------------------------------------------------------------------
    root    = Role.create(:name => 'root')
    user    = Role.create(:name => 'user')
    teacher = Role.create(:name => 'teacher')

    # NOTE: erase before deploy
    User.find_by_username('root').roles << root

    #-------------------------------------------------------------------------
    # rights
    #-------------------------------------------------------------------------

    # NOTE: users
    users_edit    = Right.create(:name => 'users_edit',
    :controller => 'users',
    :action     => 'edit')

    users_update  = Right.create(:name => 'users_update',
    :controller => 'users',
    :action     => 'update')

    # NOTE: stories
    stories_new    = Right.create(:name => 'stories_new',
    :controller => 'stories',
    :action     => 'new')

    stories_create = Right.create(:name => 'stories_create',
    :controller => 'stories',
    :action     => 'create')

    stories_edit   = Right.create(:name => 'stories_edit',
    :controller => 'stories',
    :action     => 'edit')

    stories_update  = Right.create(:name => 'stories_update',
    :controller => 'stories',
    :action     => 'update')

    # NOTE: injection
    user.rights << users_edit << users_update << stories_new << stories_create << stories_edit << stories_update
    teacher.rights << users_edit << users_update << stories_new << stories_create << stories_edit << stories_update
  end

  # ==========================================================================
  # version DOWN
  # ==========================================================================
  def self.down
    # ========================================================================
    # drop tables
    # ========================================================================
    drop_table :roles_users
    drop_table :roles
    drop_table :rights
    drop_table :rights_roles
  end
end