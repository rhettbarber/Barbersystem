require 'test_helper'

class BootstrapControllerTest < ActionController::TestCase
  test "should get development" do
    get :development
    assert_response :success
  end

  test "should get experiment" do
    get :experiment
    assert_response :success
  end

  test "should get production" do
    get :production
    assert_response :success
  end

end
