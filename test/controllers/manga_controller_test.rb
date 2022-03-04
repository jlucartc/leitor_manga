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

  test "deve rejeitar criar um mangá sem titulo" do
    sign_in(usuarios(:one))
    post cadastrar_manga_path, params: {descricao: 'Descrição do mangá', capa: fixture_file_upload('images/naruto.jpeg','image/jpeg')}
    assert flash[:danger].present?
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

  test "deve rejeitar criar um capitulo sem titulo" do
    sign_in(usuarios(:one))
    post cadastrar_capitulo_path, params: {manga_id: 1, imagens: [
      fixture_file_upload('images/naruto.jpeg','image/jpeg'),
      fixture_file_upload('images/bleach.jpeg','image/jpeg'),
      fixture_file_upload('images/onepiece.jpeg','image/jpeg')
    ]}
    assert flash[:danger].present?
  end

  test "atualiza manga" do
    sign_in(usuarios(:one))
    manga = Manga.find(1)
    post atualizar_manga_path, params: {manga_id: 1, titulo: 'Novo titulo do primeiro mangá', descricao: manga.descricao, finalizado: manga.finalizado}
    assert Manga.find(1).titulo == 'Novo titulo do primeiro mangá'
  end

  test "atualiza capitulo" do
    sign_in(usuarios(:one))
    capitulo = Capitulo.find(1)
    post atualizar_capitulo_path, params: {capitulo_id: 1, titulo: 'Novo titulo do capitulo'}
    assert Capitulo.find(1).titulo == 'Novo titulo do capitulo'
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

  test "deve excluir mangá criado pelo usuario" do
    sign_in(usuarios(:one))
    post excluir_manga_path, params: {manga_id: 1}
    assert Manga.where(id: 1).empty?
  end

  test "não deve excluir mangá de outro usuario" do
    sign_in(usuarios(:one))
    post excluir_manga_path, params: {manga_id: 2}
    assert Manga.where(id: 2).present?
  end

  test "deve criar mangá mesmo sem a capa" do
    sign_in(usuarios(:one))
    post cadastrar_manga_path, params: {titulo: 'Novo Mangá', descricao: 'Descrição do mangá'}
    assert Manga.where(titulo: 'Novo Mangá').present? and flash[:danger].present?
  end

  test "usuário favorita mangá" do
    sign_in(usuarios(:one))
    get favoritar_manga_path(manga_id: 1)
    assert Favorito.where(usuario_id: usuarios(:one).id, manga_id: 1).present?
  end

  test "usuário desfavorita mangá" do
    sign_in(usuarios(:one))
    get favoritar_manga_path(manga_id: 1)
    get desfavoritar_manga_path(manga_id: 1)
    assert Favorito.where(usuario_id: usuarios(:one).id, manga_id: 1).empty?
  end

  test "usuário não deve poder favoritar mangá que já pertence a seus favoritos" do
    sign_in(usuarios(:one))
    get favoritar_manga_path(manga_id: 1)
    get favoritar_manga_path(manga_id: 1)
    assert flash[:danger].present?
  end

  test "usuário não deve poder desfavoritar mangá que não é seu favorito" do
    sign_in(usuarios(:one))
    get desfavoritar_manga_path(manga_id: 1)
    assert flash[:danger].present?
  end

end
