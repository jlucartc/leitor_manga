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


  test "rejeita login com email não cadastrado" do
    post api_login_path, params: {email: 'three@gmail.com', password: '123457'}
    assert_response :unauthorized
  end

  test "rejeita login caso email não tenha sido enviado" do
    post api_login_path, params: {password: '123457'}
    assert_response :unauthorized
  end

  test "rejeita login caso senha não tenha sido enviada" do
    post api_login_path, params: {email: 'three@gmail.com'}
    assert_response :unauthorized
  end

  test "recupera lista de favoritos de usuário" do
    post api_favoritos_path, params: {token: "token1"}
    assert_response :success
    assert response_body["favoritos"].count == Token.find_by(codigo: "token1").usuario.favoritos.count
  end

  test "não deve recuperar lista de favoritos de usuário com token inválido" do
    post api_favoritos_path, params: {token: "tokenInvalido"}
    assert_response :unauthorized
  end

  test "não deve recuperar lista de favoritos de usuário caso token não tenha sido enviado" do
    post api_favoritos_path, params: {}
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

  test "não deve favoritar um mangá caso token não tenha sido enviado" do
    post api_favoritar_manga_path, params: {manga_id: 1}
    assert_response :unauthorized
  end

  test "não deve favoritar um mangá caso id do mangá não tenha sido enviado" do
    post api_favoritar_manga_path, params: {token: "token1"}
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

  test "não deve desfavoritar um mangá caso token não tenha sido enviado" do
    post api_desfavoritar_manga_path, params: {manga_id: 3}
    assert_response :unauthorized
  end

  test "não deve desfavoritar um mangá caso id do manga não tenha sido enviado" do
    post api_desfavoritar_manga_path, params: {token: "token1"}
    assert_response :unauthorized
  end

  test "deve retornar páginas de um mangá" do
    post api_ler_manga_path, params: {token: "token1", manga_id: 1, sequencia_capitulo: 1}
    assert_response :success
    assert response_body["paginas"].count == Pagina.joins(capitulo: :manga).where('mangas.id' => 1,'capitulos.sequencia' => 1).count
  end

  test "não deve retonar páginas de uma mangá para usuário com token inválido" do
    post api_ler_manga_path, params: {token: "tokenInvalido", manga_id: 1, sequencia_capitulo: 1}
    assert_response :unauthorized
  end

  test "não deve retornar páginas de um mangá não cadastrado" do
    post api_ler_manga_path, params: {token: "token1", manga_id: 0, sequencia_capitulo: 1}
    assert_response :unauthorized
  end

  test "não deve retornar páginas de um capítulo não cadastrado" do
    post api_ler_manga_path, params: {token: "token1", manga_id: 1, sequencia_capitulo: -1}
    assert_response :unauthorized
  end

  test "não deve retornar páginas caso token não tenha sido informado" do
    post api_ler_manga_path, params: {manga_id: 1, sequencia_capitulo: 1}
    assert_response :unauthorized
  end

  test "não deve retornar páginas caso id do manga não tenha sido informado" do
    post api_ler_manga_path, params: {token: "token1", sequencia_capitulo: 1}
    assert_response :unauthorized
  end

  test "não deve retornar páginas caso sequencia do capítulo não tenha sido informada" do
    post api_ler_manga_path, params: {token: "token1", manga_id: 1}
    assert_response :unauthorized
  end

  test "deve retornar dados de um mangá" do
    post api_ver_manga_path, params: {token: "token1", manga_id: 1}
    assert_response :success
    assert response_body["manga"]["id"] == 1
  end

  test "não deve retornar dados de um mangá para usuário com token inválido" do
    post api_ver_manga_path, params: {token: "tokenInvalido", manga_id: 1}
    assert_response :unauthorized
  end

  test "não deve retonar dados de uma mangá não cadastrado" do
    post api_ver_manga_path, params: {token: "token1", manga_id: 0}
    assert_response :unauthorized
  end

  test "não deve retonar dados do mangá caso o token não tenha sido enviado" do
    post api_ver_manga_path, params: {manga_id: 0}
    assert_response :unauthorized
  end

  test "não deve retonar dados do mangá caso o id não tenha sido enviado" do
    post api_ver_manga_path, params: {token: 'token1'}
    assert_response :unauthorized
  end

  test "deve buscar mangás" do
    post api_buscar_manga_path, params: {token: "token1", busca: 'Naruto Bleach'}
    assert_response :success
  end

  test "não deve buscar mangás para um usuário com token inválido" do
    post api_buscar_manga_path, params: {token: "tokenInvalido", busca: 'Naruto Bleach'}
    assert_response :unauthorized
  end

  test "não deve buscar mangás para um usuário caso token não tenha sido enviado" do
    post api_buscar_manga_path, params: {busca: 'Naruto Bleach'}
    assert_response :unauthorized
  end

  test "não deve buscar mangás para um usuário caso string de busca não tenha sido enviada" do
    post api_buscar_manga_path, params: {token: 'token1'}
    assert_response :unauthorized
  end

  test "cadastra novo usuario" do
    post api_cadastrar_usuario_path, params: {email: 'user@gmail.com', password: '123456', password_confirmation: '123456'}
    assert_response :success
    assert response_body["token"].present?
  end

  test "não deve cadastrar usuario com email já existente no banco" do
    post api_cadastrar_usuario_path, params: {email: 'one@gmail.com', password: '123456', password_confirmation: '123456'}
    assert_response :unauthorized
  end

  test "não deve cadastrar usuario caso email não tenha sido informado" do
    post api_cadastrar_usuario_path, params: {password: '123456', password_confirmation: '123456'}
    assert_response :unauthorized
  end

  test "não deve cadastrar usuario caso password não tenha sido informado" do
    post api_cadastrar_usuario_path, params: {email: 'user@gmail.com', password_confirmation: '123456'}
    assert_response :unauthorized
  end

  test "não deve cadastrar usuario caso password_confirmation não tenha sido informado" do
    post api_cadastrar_usuario_path, params: {email: 'user@gmail.com', password: '123456'}
    assert_response :unauthorized
  end

end
