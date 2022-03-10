require "test_helper"

class ApiControllerTest < ActionDispatch::IntegrationTest
  test "autoriza usuario" do
    post api_login_path, params: {email: 'one@gmail.com', password: '123456'}
    assert_response :success
  end

  test "rejeita login com senha errada" do
    post api_login_path, params: {email: 'one@gmail.com', password: '123457'}
    assert_response :unauthorized
  end


  test "rejeita login com email inexistente" do
    post api_login_path, params: {email: 'three@gmail.com', password: '123457'}
    assert_response :unauthorized
  end
end
