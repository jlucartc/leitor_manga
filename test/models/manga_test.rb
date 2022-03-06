require "test_helper"

class MangaTest < ActiveSupport::TestCase
  test "ao destruir um mangá, todos os seus capítulos, capas e favoritos devem ser deletados do banco" do
    capa = Capa.find(1)
    capa.arquivo = pega_conteudo_imagem
    capa.save
    Manga.find(1).destroy
    assert Manga.where(id: 1).empty? and Capa.where(manga_id: 1).empty? and Capitulo.where(manga_id: 1).empty? and Favorito.where(manga_id: 1).empty?
  end
end
