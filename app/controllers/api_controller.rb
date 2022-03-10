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
	end

	def desfavoritar_manga
	end

	def baixar_capitulos
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
