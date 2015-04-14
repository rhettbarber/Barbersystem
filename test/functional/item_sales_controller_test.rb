require 'test_helper'

class ItemSalesControllerTest < ActionController::TestCase
  setup do
    @item_sale = item_sales(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:item_sales)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create item_sale" do
    assert_difference('ItemSale.count') do
      post :create, item_sale: {  }
    end

    assert_redirected_to item_sale_path(assigns(:item_sale))
  end

  test "should show item_sale" do
    get :show, id: @item_sale
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @item_sale
    assert_response :success
  end

  test "should update item_sale" do
    put :update, id: @item_sale, item_sale: {  }
    assert_redirected_to item_sale_path(assigns(:item_sale))
  end

  test "should destroy item_sale" do
    assert_difference('ItemSale.count', -1) do
      delete :destroy, id: @item_sale
    end

    assert_redirected_to item_sales_path
  end
end
