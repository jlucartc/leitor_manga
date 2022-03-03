require "test_helper"

class CapituloTest < ActiveSupport::TestCase
  test "ao destruir um capítulo, todas as suas imagens devem ser destruídas" do
    imagens = Imagem.where(capitulo_id: 1)
    imagens.each{|imagem| imagem.arquivo = pega_conteudo_imagem; imagem.save}
    Capitulo.find(1).destroy
    assert Imagem.where(capitulo_id: 1).empty?
  end
end
