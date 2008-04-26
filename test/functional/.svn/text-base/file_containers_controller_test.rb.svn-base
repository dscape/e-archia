require File.dirname(__FILE__) + '/../test_helper'

class FileContainersControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:file_containers)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_file_container
    assert_difference('FileContainer.count') do
      post :create, :file_container => { }
    end

    assert_redirected_to file_container_path(assigns(:file_container))
  end

  def test_should_show_file_container
    get :show, :id => file_containers(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => file_containers(:one).id
    assert_response :success
  end

  def test_should_update_file_container
    put :update, :id => file_containers(:one).id, :file_container => { }
    assert_redirected_to file_container_path(assigns(:file_container))
  end

  def test_should_destroy_file_container
    assert_difference('FileContainer.count', -1) do
      delete :destroy, :id => file_containers(:one).id
    end

    assert_redirected_to file_containers_path
  end
end
