require "test_helper"

class MangaControllerTest < ActionDispatch::IntegrationTest

  setup do
    desabilita_autenticacao_csrf
  end

  teardown do
    habilita_autenticacao_csrf
  end

  test "cria um novo mangá" do
    sign_in(usuarios(:one))
    post cadastrar_manga_path, params: {titulo: 'Novo Mangá', descricao: 'Descrição do mangá', capa: fixture_file_upload('images/naruto.jpeg','image/jpeg')}
    assert Manga.where(titulo: 'Novo Mangá').present?
  end

  test "cria um capítulo em um mangá existente" do
    sign_in(usuarios(:one))
    post cadastrar_capitulo_path, params: {manga_id: 1, titulo: 'Capítulo 2', imagens: [
      {sequencia: 1, arquivo: fixture_file_upload('images/naruto.jpeg','image/jpeg')},
      {sequencia: 2, arquivo: fixture_file_upload('images/bleach.jpeg','image/jpeg')},
      {sequencia: 3, arquivo: fixture_file_upload('images/onepiece.jpeg','image/jpeg')}
    ]}
    assert Capitulo.where(manga_id: 1).present? and Capitulo.where(manga_id: 1).last.titulo == 'Capitulo 2'
  end

  test "ao deletar um mangá, todos os seus capítulos e sua capa devem ser deletados do banco" do
    sign_in(usuarios(:one))
    Capa.find(1).update(arquivo: pega_conteudo_imagem)
    Manga.find(1).destroy
    assert Capa.where(manga_id: 1).empty? and Capitulo.where(manga_id: 1).empty?
  end

end
