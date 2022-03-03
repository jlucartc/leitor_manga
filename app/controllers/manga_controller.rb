class MangaController < ApplicationController

	before_action :authenticate_usuario!


	def meus_mangas
	end
	
	def favoritos
	end
	
	def buscar
	end
	
	def ver_manga
	end
	
	def novo_manga
	end
	
	def novo_capitulo
	end
	
	def editar_manga
	end
	
	def editar_capitulo
	end
	
	def cadastrar_manga
		manga = Manga.new(titulo: params[:titulo], autor_id: current_usuario.id ,descricao: params[:descricao])
		if manga.save
			
			cover = Capa.new(manga_id: manga.id,arquivo: params[:capa].tempfile.read)

			if !cover.save
				flash[:danger] = "Erro no upload da capa do mangá."
			end

			flash[:success] = "Mangá criado com sucesso!"
			redirect_to meus_mangas_path
		else
			flash[:danger] = "Erro na criação do mangá"
			redirect_to novo_manga_path
		end
	end
	
	def cadastrar_capitulo
	end
	
	def atualizar_manga
	end
	
	def atualizar_capitulo
	end
	
	def excluir_capitulo
	end
	
	def excluir_manga
	end
	

end