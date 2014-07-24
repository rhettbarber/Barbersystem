require 'test_helper'

class ItemSetsControllerTest < ActionController::TestCase
  setup do
    @item_set = item_sets(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:item_sets)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create item_set" do
    assert_difference('ItemSet.count') do
      post :create, item_set: { category_id: @item_set.category_id, department_id: @item_set.department_id, item_id: @item_set.item_id, opposite_category_ids: @item_set.opposite_category_ids, opposite_department_ids: @item_set.opposite_department_ids, opposite_item_ids: @item_set.opposite_item_ids }
    end

    assert_redirected_to item_set_path(assigns(:item_set))
  end

  test "should show item_set" do
    get :show, id: @item_set
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @item_set
    assert_response :success
  end

  test "should update item_set" do
    put :update, id: @item_set, item_set: { category_id: @item_set.category_id, department_id: @item_set.department_id, item_id: @item_set.item_id, opposite_category_ids: @item_set.opposite_category_ids, opposite_department_ids: @item_set.opposite_department_ids, opposite_item_ids: @item_set.opposite_item_ids }
    assert_redirected_to item_set_path(assigns(:item_set))
  end

  test "should destroy item_set" do
    assert_difference('ItemSet.count', -1) do
      delete :destroy, id: @item_set
    end

    assert_redirected_to item_sets_path
  end
end
