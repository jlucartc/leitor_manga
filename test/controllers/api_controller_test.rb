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

  test "recupera lista de favoritos de usuário" do
    post api_favoritos_path, params: {token: "token1"}
    assert_response :success
  end

  test "não deve recuperar lista de favoritos de usuário com token inválido" do
    post api_favoritos_path, params: {token: "tokenInvalido"}
    assert_response :unauthorized
  end

  test "adiciona um mangá à lista de favoritos do usuário" do
    post api_favoritar_manga_path, params: {token: "token1", manga_id: 3}
    assert_response :success
  end

  test "não deve adicionar um mangá à lista de favoritos de usuário com token inválido" do
    post api_favoritar_manga_path, params: {token: "tokenInvalido", manga_id: 3}
    assert_response :unauthorized
  end

  test "não deve favoritar um mangá que já é favorito do usuário" do
    post api_favoritar_manga_path, params: {token: "token1", manga_id: 1}
    assert_response :unauthorized
  end

  test "remove um mangá da lista de favoritos do usuário" do
    post api_desfavoritar_manga_path, params: {token: "token1", manga_id: 1}
    assert_response :success
  end

  test "não deve remover um mangá da lista de favoritos do usuário com token inválido" do
    post api_desfavoritar_manga_path, params: {token: "tokenInvalido", manga_id: 1}
    assert_response :unauthorized
  end

  test "não deve desfavoritar um mangá que não é favorito do usuário" do
    post api_desfavoritar_manga_path, params: {token: "token1", manga_id: 3}
    assert_response :unauthorized
  end

end
