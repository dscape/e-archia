# ============================================================================
# e-archia: create_projects migration                                      005
# author: nunojobpinto[at]gmail[dot]com                                      
# ============================================================================
class CreateProjects < ActiveRecord::Migration
  # ==========================================================================
  # version UP
  # ==========================================================================
  def self.up
    # ========================================================================
    # create tables
    # ========================================================================
    create_table :projects do |t|
      t.integer  :user_id,     :default => 1,  :null => false
      t.string   :title,       :limit => 256,  :null => false
      t.string   :subtitle,    :limit => 256
      t.string   :filepath
      t.string   :filename
      t.integer  :acm,         :default => 1,  :null => false
      t.text     :contents,    :limit => 2048, :null => false
      t.text     :authors,     :limit => 2048, :null => false
      t.text     :supervisors, :limit => 2048, :null => false
      t.string   :permalink,   :limit => 256,  :null => false
      t.timestamps
    end

    # ========================================================================
    #  make indexes
    # ========================================================================
    add_index :projects, :permalink

    # ========================================================================
    # create some data
    # ========================================================================

    #-------------------------------------------------------------------------
    # roles
    #-------------------------------------------------------------------------
    teacher = Role.find_by_name('teacher')

    #-------------------------------------------------------------------------
    # rights
    #-------------------------------------------------------------------------

    # NOTE: project
    projects_new     = Right.create(:name => 'projects_new',
    :controller => 'projects',
    :action     => 'new')

    projects_create  = Right.create(:name => 'projects_create',
    :controller => 'projects',
    :action     => 'create')

    projects_edit    = Right.create(:name => 'projects_edit',
    :controller => 'projects',
    :action     => 'edit')

    projects_update  = Right.create(:name => 'projects_update',
    :controller => 'projects',
    :action     => 'update')

    projects_index   = Right.create(:name => 'projects_index',
    :controller => 'projects',
    :action     => 'index')

    projects_show_by_permalink = Right.create(:name => 'projects_show_by_permalink',
    :controller => 'projects',
    :action     => 'show_by_permalink')

    projects_search = Right.create(:name => 'projects_search',
    :controller => 'projects',
    :action     => 'search')

    projects_show   = Right.create(:name => 'projects_show',
    :controller => 'projects',
    :action     => 'show')

    projects_destroy   = Right.create(:name => 'projects_destroy',
    :controller => 'projects',
    :action     => 'destroy')

    # NOTE: injection
    teacher.rights << projects_new << projects_create << projects_edit << projects_update << projects_index << projects_show_by_permalink << projects_search << projects_show << projects_destroy
  end

  # ==========================================================================
  # version DOWN
  # ==========================================================================
  def self.down
    # ========================================================================
    # drop tables
    # ========================================================================
    # Retirar a tabela de projectos
    drop_table :projects
  end
end
