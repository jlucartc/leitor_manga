Rails.application.routes.draw do
  devise_for :usuarios
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "application#index"
  get "/manga", to: "manga#meus_mangas", as: "meus_mangas"
  get "/manga/favoritos", to: "manga#favoritos", as: "favoritos"
  get "/manga/buscar", to: "manga#buscar", as: "buscar_manga"
  get "/manga/ver", to: "manga#ver_manga", as: "ver_manga"
  get "/manga/novo", to: "manga#novo_manga", as: "novo_manga"
  get "/capitulo/novo", to: "manga#novo_capitulo", as: "novo_capitulo"
  get "/manga/editar", to: "manga#editar_manga", as: "editar_manga"
  get "/capitulo/editar", to: "manga#editar_capitulo", as: "editar_capitulo"
  post "/manga/cadastrar", to: "manga#cadastrar_manga", as: "cadastrar_manga"
  post "/capitulo/cadastrar", to: "manga#cadastrar_capitulo", as: "cadastrar_capitulo"
  post "/manga/atualizar", to: "manga#atualizar_manga", as: "atualizar_manga"
  post "/capitulo/atualizar", to: "manga#atualizar_capitulo", as: "atualizar_capitulo"
  post "/capitulo/excluir", to: "manga#excluir_capitulo", as: "excluir_capitulo"
  post "/manga/excluir", to: "manga#excluir_manga", as: "excluir_manga"
  get "/api/manga/ver", to: "api#ver_manga", as: "api_ver_manga"
  get "/api/manga/buscar", to: "api#buscar_manga", as: "api_buscar_manga"
  get "/api/manga/ler", to: "api#ler_manga", as: "api_ler_manga"
  post "/api/usuario/cadastrar", to: "api#cadastrar_usuario", as: "api_cadastrar_usuario"
  get "/api/manga/favoritar", to: "api#favoritar_manga", as: "api_favoritar_manga"
  get "/api/manga/desfavoritar", to: "api#desfavoritar_manga", as: "api_desfavoritar_manga"
  get "/api/capitulos/baixar", to: "api#baixar_capitulos", as: "api_baixar_capitulos"
  post "/api/usuario/login", to: "api#usuario_login", as: "api_usuario_login"
end