require "test_helper"

class CapituloTest < ActiveSupport::TestCase
  test "ao destruir um capítulo, todas as suas imagens devem ser destruídas" do
    Capitulo.find(1).destroy
    assert Imagem.where(capitulo_id: 1).empty?
  end
end
