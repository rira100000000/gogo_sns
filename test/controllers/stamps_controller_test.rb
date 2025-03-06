require "test_helper"

class StampsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get stamps_create_url
    assert_response :success
  end

  test "should get destroy" do
    get stamps_destroy_url
    assert_response :success
  end
end
