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
    post cadastrar_capitulo_path, params: {manga_id: 1, titulo: 'Capítulo 2', paginas: [
      fixture_file_upload('images/naruto.jpeg','image/jpeg'),
      fixture_file_upload('images/bleach.jpeg','image/jpeg'),
      fixture_file_upload('images/onepiece.jpeg','image/jpeg')
    ], sequencia_paginas: [{nome: "naruto.jpeg",sequencia: 1}.to_json,{nome: "bleach.jpeg",sequencia: 2}.to_json,{nome: "onepiece.jpeg",sequencia: 3}.to_json]}
    assert Capitulo.where(manga_id: 1).present? and Capitulo.where(manga_id: 1).last.titulo == 'Capitulo 2'
  end

  test "deve rejeitar criar um capitulo sem titulo" do
    sign_in(usuarios(:one))
    post cadastrar_capitulo_path, params: {manga_id: 1, paginas: [
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
    post atualizar_capitulo_path, params: {capitulo_id: 1, titulo: 'Novo titulo do capitulo', sequencia_paginas: gera_sequencia_paginas(capitulo)}
    assert Capitulo.find(1).titulo == 'Novo titulo do capitulo'
  end

  test "deve rejeitar atualizar mangá sem titulo" do
    sign_in(usuarios(:one))
    post atualizar_manga_path, params: {manga_id: 1}
    assert flash[:danger].present? 
  end

  test "deve rejeitar atualizar capitulo sem titulo" do
    sign_in(usuarios(:one))
    capitulo = Capitulo.find(1)
    post atualizar_capitulo_path, params: {capitulo_id: 1, sequencia_paginas: gera_sequencia_paginas(capitulo)}
    assert flash[:danger].present?
  end

  test "adiciona capa em um mangá" do
    sign_in(usuarios(:one))
    assert Capa.where(manga_id: 3).empty?
    post atualizar_manga_path, params: {manga_id: 3, capa: fixture_file_upload('images/naruto.jpeg')}
    assert Capa.where(manga_id: 3).present?
  end

  test "troca capa em um mangá" do
    sign_in(usuarios(:one))
    capa = Capa.where(manga_id: 1).first
    assert capa.present?
    updated_at = capa.updated_at
    post atualizar_manga_path, params: {manga_id: 1, capa: fixture_file_upload('images/naruto.jpeg')}
    assert Capa.where(manga_id: 1).first.updated_at > updated_at
  end

  test "remove paginas de um capitulo de manga" do
    sign_in(usuarios(:one))
    capitulo = Capitulo.find(capitulos(:naruto_capitulo_1).id)
    total_paginas_inicial = capitulo.paginas.count
    post atualizar_capitulo_path, params: {capitulo_id: capitulo.id, sequencia_paginas: gera_sequencia_paginas(capitulo).first(3)}
    assert capitulo.paginas.count < total_paginas_inicial
  end

  test "insere nova pagina em um capitulo" do
    sign_in(usuarios(:one))
    capitulo = Capitulo.find(capitulos(:naruto_capitulo_1).id)
    primeira_pagina_updated_at = capitulo.paginas.where(sequencia: 1).first.updated_at
    ultima_sequencia = capitulo.paginas.order(:sequencia).last.sequencia
    post atualizar_capitulo_path, params: {capitulo_id: capitulo.id, sequencia_paginas: gera_sequencia_paginas(capitulo) + [{nome: 'naruto_2.jpeg', sequencia: ultima_sequencia+1}.to_json] , paginas: [fixture_file_upload('images/naruto_2.jpeg','image/jpeg')]}
    assert capitulo.paginas.order(:sequencia).last.sequencia = ultima_sequencia+1
  end

  test "insere pagina com sequencia duplicada em um capitulo " do
    sign_in(usuarios(:one))
    capitulo = Capitulo.find(capitulos(:naruto_capitulo_1).id)
    primeira_pagina_updated_at = capitulo.paginas.where(sequencia: 1).first.updated_at
    post atualizar_capitulo_path, params: {capitulo_id: capitulo.id, sequencia_paginas: gera_sequencia_paginas(capitulo) + [{nome: 'naruto_2.jpeg', sequencia: 1}.to_json] , paginas: [fixture_file_upload('images/naruto_2.jpeg','image/jpeg')]}
    assert capitulo.paginas.where(sequencia: 1).first.updated_at == primeira_pagina_updated_at
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
    get favoritar_manga_path(manga_id: 3)
    assert Favorito.where(usuario_id: usuarios(:one).id, manga_id: 3).present?
  end

  test "usuário desfavorita mangá" do
    sign_in(usuarios(:one))
    get favoritar_manga_path(manga_id: 3)
    get desfavoritar_manga_path(manga_id: 3)
    assert Favorito.where(usuario_id: usuarios(:one).id, manga_id: 3).empty?
  end

  test "usuário não deve poder favoritar mangá que já pertence a seus favoritos" do
    sign_in(usuarios(:one))
    get favoritar_manga_path(manga_id: 3)
    get favoritar_manga_path(manga_id: 3)
    assert flash[:danger].present?
  end

  test "usuário não deve poder desfavoritar mangá que não é seu favorito" do
    sign_in(usuarios(:one))
    get desfavoritar_manga_path(manga_id: 3)
    assert flash[:danger].present?
  end

end
