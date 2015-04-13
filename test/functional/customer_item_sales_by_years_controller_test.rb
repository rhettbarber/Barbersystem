require 'test_helper'

class CustomerItemSalesByYearsControllerTest < ActionController::TestCase
  setup do
    @customer_item_sales_by_year = customer_item_sales_by_years(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:customer_item_sales_by_years)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create customer_item_sales_by_year" do
    assert_difference('CustomerItemSalesByYear.count') do
      post :create, customer_item_sales_by_year: {  }
    end

    assert_redirected_to customer_item_sales_by_year_path(assigns(:customer_item_sales_by_year))
  end

  test "should show customer_item_sales_by_year" do
    get :show, id: @customer_item_sales_by_year
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @customer_item_sales_by_year
    assert_response :success
  end

  test "should update customer_item_sales_by_year" do
    put :update, id: @customer_item_sales_by_year, customer_item_sales_by_year: {  }
    assert_redirected_to customer_item_sales_by_year_path(assigns(:customer_item_sales_by_year))
  end

  test "should destroy customer_item_sales_by_year" do
    assert_difference('CustomerItemSalesByYear.count', -1) do
      delete :destroy, id: @customer_item_sales_by_year
    end

    assert_redirected_to customer_item_sales_by_years_path
  end
end
