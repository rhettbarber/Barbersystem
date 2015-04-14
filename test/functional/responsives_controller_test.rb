require 'test_helper'

class ResponsivesControllerTest < ActionController::TestCase
  setup do
    @responsife = responsives(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:responsives)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create responsife" do
    assert_difference('Responsive.count') do
      post :create, responsife: {  }
    end

    assert_redirected_to responsife_path(assigns(:responsife))
  end

  test "should show responsife" do
    get :show, id: @responsife
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @responsife
    assert_response :success
  end

  test "should update responsife" do
    put :update, id: @responsife, responsife: {  }
    assert_redirected_to responsife_path(assigns(:responsife))
  end

  test "should destroy responsife" do
    assert_difference('Responsive.count', -1) do
      delete :destroy, id: @responsife
    end

    assert_redirected_to responsives_path
  end
end
