require 'test_helper'

class CrawlControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get start" do
    get :start
    assert_response :success
  end

end
