require "test_helper"

class BankStatementsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get bank_statements_new_url
    assert_response :success
  end

  test "should get create" do
    get bank_statements_create_url
    assert_response :success
  end
end
