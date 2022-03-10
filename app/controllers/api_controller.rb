class ApiController < ApplicationController
	skip_before_action :verify_authenticity_token

	def ver_manga
	end

	def buscar_manga
	end

	def ler_manga
	end

	def cadastrar_usuario
	end

	def favoritar_manga
		manga = Manga.find(params[:manga_id])
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
		manga = Manga.find(params[:manga_id])
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
			render json: {favoritos: Favorito.where(usuario_id: token.usuario).map{|fav| fav.manga }}
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

end
