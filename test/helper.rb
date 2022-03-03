module Helper
  def desabilita_autenticacao_csrf
    ActionController::Base.allow_forgery_protection = false
  end

  def habilita_autenticacao_csrf
    ActionController::Base.allow_forgery_protection = true
  end

  def pega_conteudo_imagem
    File.open('test/fixtures/files/images/naruto.jpeg').read()
  end

end