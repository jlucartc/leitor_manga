class ApiController < ApplicationController
	skip_before_action :verify_authenticity_token

	def ver_manga
		manga = Manga.where(id: params[:manga_id])
		token = Token.find_by(codigo: params[:token])
		if manga.present? and token.present?
			render json: {manga: formata_lista_mangas(manga).first}
		else
			render json: {mensagem: 'Requisição inválida'}, status: :unauthorized
		end
	end

	def buscar_manga
		token = Token.find_by(codigo: params[:token])
		palavras = params[:busca]
		if token.present? and palavras.present?
			palavras = palavras.split(' ')
			palavras.each do |palavra|
				@resultados = Manga.where('titulo like ?',"%#{palavra}%") if @resultados.nil?
				@resultados = @resultados.or(Manga.where('titulo like ?',"%#{palavra}%")) if @resultados.present?
			end
			render json: {resultados: formata_lista_mangas(@resultados)}
		else
			render json: {mensagem: 'Requisição inválida'}, status: :unauthorized
		end
	end

	def ler_manga
		manga = Manga.where(params[:manga_id])
		token = Token.find_by(codigo: params[:token])

		if token.present? and manga.present?
			manga = manga.first
			capitulo = Capitulo.where(manga_id: params[:manga_id], sequencia: params[:sequencia_capitulo]).first
			if capitulo.present?
				paginas = Pagina.where(capitulo_id: capitulo.id)
				render json: { paginas: formata_lista_paginas(paginas)}
			else
				render json: {mensagem: 'Capítulo inexistente'}, status: :unauthorized
			end
		else
			render json: {mensagem: 'Requisicao Inválida'}, status: :unauthorized
		end
	end

	def cadastrar_usuario
		usuario = Usuario.new(email: params[:email], password: params[:password], password_confirmation: params[:password_confirmation])
		if usuario.save
			token = Token.create(usuario_id: usuario.id)
			render json: {token: token.codigo}
		else
			render json: {mensagem: 'Cadastro inválido.'}, status: :unauthorized
		end
	end

	def favoritar_manga
		manga = Manga.find_by(id: params[:manga_id])
		token = Token.find_by(codigo: params[:token])
		if manga.present? and token.present?
			favorito = Favorito.where(usuario_id: token.usuario.id, manga_id: manga.id).first
			if favorito.present?
				render json: {mensagem: 'Mangá já pertence aos favoritos'}, status: :unauthorized
			else
				render json: {mensagem: 'Mangá foi adicionado aos favoritos'}
			end
		else
			render json: {mensagem: 'Requisição inválida'}, status: :unauthorized
		end
	end

	def desfavoritar_manga
		manga = Manga.find_by(id: params[:manga_id])
		token = Token.find_by(codigo: params[:token])
		if manga.present? and token.present?
			favorito = Favorito.where(usuario_id: token.usuario.id, manga_id: manga.id).first
			if favorito.present?
				favorito.destroy
				render json: {mensagem: 'Mangá foi removido dos favoritos'}
			else
				render json: {mensagem: 'Mangá não pertence aos favoritos'}, status: :unauthorized
			end
		else
			render json: {mensagem: 'Requisição inválida'}, status: :unauthorized
		end
	end

	def baixar_capitulos
	end

	def favoritos
		token = Token.find_by(codigo: params[:token])
		if token.present?
			mangas_favoritos = Manga.joins(:favoritos).where('favoritos.usuario_id' => token.usuario_id)
			render json: {favoritos: formata_lista_mangas(mangas_favoritos)}
		else
			render json: {mensagem: 'Requisição inválida'}, status: :unauthorized
		end
	end

	def login
		usuario = Usuario.find_by(email: params[:email])
		if usuario.present? and usuario.valid_password?(params[:password])
			Token.create(usuario_id: usuario.id)
			render json: {token: usuario.tokens.last.codigo}
		else
			render json: {mensagem: 'Credenciais inválidas'}, status: :unauthorized
		end
	end

	private

		def formata_lista_mangas(mangas)
			campos_autorizados = ['id','titulo','descricao','finalizado']
			mangas = mangas.map{|manga| manga.as_json.filter{|campo| campos_autorizados.include?(campo) } }
			mangas = mangas.map{|manga| manga_row = Manga.find(manga["id"]); manga["capa_path"] = manga_row.capa.present? ? manga_row.capa.path : '/dummy.png'; manga }
			mangas
		end

		def formata_lista_paginas(paginas)
			campos_autorizados = ['id','sequencia','capitulo_id']
			paginas = paginas.map{|pagina| pagina.as_json.filter{|campo| campos_autorizados.include?(campo) } }
			paginas = paginas.map{|pagina| pagina["path"] = Pagina.where(sequencia: pagina["sequencia"], capitulo_id: pagina["capitulo_id"]).first.path; pagina }
			paginas = paginas.map{|pagina| 
				pagina.delete("capitulo_id");
				pagina["sequencia_capitulo"] = Pagina.find(pagina["id"]).capitulo.sequencia;
				pagina.delete("id");
				pagina["sequencia_pagina"] = pagina["sequencia"];
				pagina.delete("sequencia");
				pagina
			}
			paginas
		end

end
