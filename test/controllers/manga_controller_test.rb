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
      fixture_file_upload('images/naruto.jpeg','image/jpeg'),
      fixture_file_upload('images/bleach.jpeg','image/jpeg'),
      fixture_file_upload('images/onepiece.jpeg','image/jpeg')
    ]}
    assert Capitulo.where(manga_id: 1).present? and Capitulo.where(manga_id: 1).last.titulo == 'Capitulo 2'
  end

  test "atualiza manga" do
    sign_in(usuarios(:one))
    manga = Manga.find(1)
    post atualizar_manga_path, params: {manga_id: 1, titulo: 'Novo titulo do primeiro mangá', descricao: manga.descricao, finalizado: manga.finalizado}
    assert Manga.find(1).titulo == 'Novo titulo do primeiro mangá'
  end

  test "deve rejeitar atualizar mangá sem titulo" do
    sign_in(usuarios(:one))
    post atualizar_manga_path, params: {manga_id: 1}
    assert flash[:danger].present? 
  end

  test "deve rejeitar atualizar capitulo sem titulo" do
    sign_in(usuarios(:one))
    post atualizar_capitulo_path, params: {capitulo_id: 1}
    assert flash[:danger].present?
  end

  test "ao destruir um capítulo, todas as suas imagens devem ser destruídas" do
    sign_in(usuarios(:one))
    imagens = Imagem.where(capitulo_id: 1)
    imagens.each{|imagem| imagem.arquivo = pega_conteudo_imagem; imagem.save}
    Capitulo.find(1).destroy
    assert Imagem.where(capitulo_id: 1).empty?
  end

  test "ao destruir um mangá, todos os seus capítulos e sua capa devem ser deletados do banco" do
    sign_in(usuarios(:one))
    capa = Capa.find(1)
    capa.arquivo = pega_conteudo_imagem
    capa.save
    Manga.find(1).destroy
    assert Manga.where(id: 1).empty? and Capa.where(manga_id: 1).empty? and Capitulo.where(manga_id: 1).empty?
  end

  test "deve excluir capitulo de um mangá do usuário" do
    sign_in(usuarios(:one))
    post excluir_capitulo_path, params: {capitulo_id: 1}
    assert Capitulo.where(id: 1).empty?
  end

  test "não deve excluir capitulo de um mangá que não é do usuário" do
    sign_in(usuarios(:one))
    post excluir_capitulo_path, params: {capitulo_id: 2}
    assert Capitulo.where(id: 2).present?
  end

  test "não deve excluir mangá de outro autor" do
    sign_in(usuarios(:one))
    post excluir_manga_path, params: {manga_id: 2}
    assert Manga.where(id: 2).present?
  end

  test "deve criar manga mesmo sem a capa" do
    sign_in(usuarios(:one))
    post cadastrar_manga_path, params: {titulo: 'Novo Mangá', descricao: 'Descrição do mangá'}
    assert Manga.where(titulo: 'Novo Mangá').present? and flash[:danger].present?
  end

end
