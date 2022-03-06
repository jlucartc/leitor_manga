module Helper

  def gera_sequencia_imagens(capitulo)
    Imagem.where(capitulo_id: capitulo.id).map{|imagem| {nome: imagem.nome, sequencia: imagem.sequencia}.to_json }
  end

  def desabilita_autenticacao_csrf
    ActionController::Base.allow_forgery_protection = false
  end

  def habilita_autenticacao_csrf
    ActionController::Base.allow_forgery_protection = true
  end

  def pega_conteudo_imagem
    File.open('test/fixtures/files/images/naruto.jpeg','rb').read()
  end

end