require "test_helper"

class CapituloTest < ActiveSupport::TestCase
  test "ao destruir um capítulo, todas as suas paginas devem ser destruídas" do
    Capitulo.find(1).destroy
    assert Pagina.where(capitulo_id: 1).empty?
  end

  test "ao destruir um capítulo, os capítulos seguintes do mesmo mangá devem ter sua sequência ajustada" do
    capitulo_atual = Capitulo.find(capitulos(:naruto_capitulo_1).id)
    capitulo_seguinte_sequencia_inicial = capitulos(:naruto_capitulo_2).sequencia
    capitulo_atual.destroy
    assert Capitulo.find(capitulos(:naruto_capitulo_2).id).sequencia == capitulo_seguinte_sequencia_inicial-1
  end

end
