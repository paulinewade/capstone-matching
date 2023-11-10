require "test_helper"

class SponsorRestrictionsControllerTest < ActionDispatch::IntegrationTest
  test "should get edit" do
    get sponsor_restrictions_edit_url
    assert_response :success
  end

  test "should get new" do
    get sponsor_restrictions_new_url
    assert_response :success
  end
end
