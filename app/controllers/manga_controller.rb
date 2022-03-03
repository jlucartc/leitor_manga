class MangaController < ApplicationController

	before_action :authenticate_usuario!


	def meus_mangas
		@mangas = Manga.where(usuario_id: current_usuario.id)
	end
	
	def favoritos
	end
	
	def favoritar_manga
		favorito = Favorito.new(manga_id: params[:manga_id],usuario_id: current_usuario.id)
		if favorito.save
			flash[:success] = "Mangá favoritado com sucesso!"
		else
			flash[:danger] = "Mangá não pode ser favoritado novamente."
		end
		redirect_to favoritos_path
	end

	def desfavoritar_manga
		favorito = Favorito.where(manga_id: params[:manga_id], usuario_id: current_usuario.id).first
		if favorito.present?
			favorito.destroy
			flash[:success] = "Mangá foi removido dos favoritos!"
		else
			flash[:danger] = "Mangá não pertence aos favoritos."
		end
		redirect_to favoritos_path
	end

	def buscar
	end
	
	def ver_manga
		@manga = Manga.find(params[:id])
		@capitulos = Capitulo.where(manga_id: @manga.id)
		@favorito = Favorito.where(manga_id: @manga.id, usuario_id: current_usuario.id)
	end
	
	def ler_manga
	end

	def novo_manga
	end
	
	def novo_capitulo
		@manga = Manga.find(params[:manga_id])
	end
	
	def editar_manga
		@manga = Manga.where(id: params[:id], usuario_id: current_usuario.id).first
		@capitulos = Capitulo.where(manga_id: @manga.id)
	end
	
	def editar_capitulo
		@capitulo = Capitulo.find(params[:id])
	end
	
	def cadastrar_manga
		manga = Manga.new(titulo: params[:titulo], usuario_id: current_usuario.id ,descricao: params[:descricao])
		if manga.save

			if params[:capa].present?
				capa = Capa.create(manga_id: manga.id,arquivo: params[:capa].tempfile.read)
			end

			flash[:success] = "Mangá criado com sucesso!"
			redirect_to meus_mangas_path
		else
			flash[:danger] = "Erro na criação do mangá"
			redirect_to novo_manga_path
		end
	end
	
	def cadastrar_capitulo
		capitulo = Capitulo.new(titulo: params[:titulo], manga_id: params[:manga_id])
		if capitulo.save
			flash[:success] = 'Capitulo criado com sucesso'
			params[:imagens].each_with_index{|imagem,index| Imagem.create(capitulo_id: capitulo.id, sequencia: index, arquivo: imagem.tempfile.read)}
			redirect_to ver_manga_path(params[:manga_id])
		else
			flash[:danger] = 'Erro na criação do capítulo'
			redirect_to novo_capitulo_path(params[:manga_id])
		end
	end
	
	def atualizar_manga
		manga = Manga.find(params[:manga_id])
		manga.titulo = params[:titulo]
		manga.descricao = params[:descricao]
		manga.finalizado = params[:finalizado]
		if manga.save
			flash[:success] = 'Mangá foi atualizado com sucesso!'
			redirect_to ver_manga_path(manga.id)
		else
			flash[:danger] = 'Erro na atualização do mangá.'
			redirect_to editar_manga_path(manga.id)
		end
	end
	
	def atualizar_capitulo
		capitulo = Capitulo.find(params[:capitulo_id])
		capitulo.titulo = params[:titulo]
		if capitulo.save
			flash[:success] = "Capítulo atualizado com sucesso!"
			redirect_to ver_manga_path(capitulo.manga_id)
		else
			flash[:danger] = "Erro na atualização do capítulo."
			redirect_to editar_capitulo_path(capitulo.id)
		end
	end
	
	def excluir_capitulo
		capitulo = Capitulo.find(params[:capitulo_id])
		manga = Manga.where(id: capitulo.manga_id, usuario_id: current_usuario.id)
		if manga.present?
			capitulo.destroy
			flash[:success] = "Capítulo excluído com sucesso!"
			redirect_to ver_manga_path(capitulo.id)
		else
			flash[:danger] = "Não foi possível excluir capítulo."
			redirect_to ver_manga_path(capitulo.manga_id)
		end
	end
	
	def excluir_manga
		manga = Manga.where(id: params[:manga_id], usuario_id: current_usuario.id).first
		if manga.present?
			manga.destroy
			flash[:success] = "Mangá excluído com sucesso!"
		else
			flash[:danger] = "Não foi possível excluir mangá."
		end
		redirect_to meus_mangas_path
	end
	

end