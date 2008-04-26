require File.dirname(__FILE__) + '/../test_helper'

class ProjectEntriesControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:project_entries)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_project_entry
    assert_difference('ProjectEntry.count') do
      post :create, :project_entry => { }
    end

    assert_redirected_to project_entry_path(assigns(:project_entry))
  end

  def test_should_show_project_entry
    get :show, :id => project_entries(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => project_entries(:one).id
    assert_response :success
  end

  def test_should_update_project_entry
    put :update, :id => project_entries(:one).id, :project_entry => { }
    assert_redirected_to project_entry_path(assigns(:project_entry))
  end

  def test_should_destroy_project_entry
    assert_difference('ProjectEntry.count', -1) do
      delete :destroy, :id => project_entries(:one).id
    end

    assert_redirected_to project_entries_path
  end
end
