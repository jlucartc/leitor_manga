class MangaController < ApplicationController

	before_action :authenticate_usuario!

	def meus_mangas
		@mangas = Manga.where(usuario_id: current_usuario.id)
	end
	
	def favoritos
		@favoritos = Favorito.where(usuario_id: current_usuario.id)
	end
	
	def favoritar_manga
		favorito = Favorito.new(manga_id: params[:manga_id],usuario_id: current_usuario.id)
		if favorito.save
			flash[:success] = "Mangá favoritado com sucesso!"
		else
			flash[:danger] = "Mangá não pode ser favoritado novamente."
		end
		redirect_to ver_manga_path(params[:manga_id])
	end

	def desfavoritar_manga
		favorito = Favorito.where(manga_id: params[:manga_id], usuario_id: current_usuario.id).first
		if favorito.present?
			favorito.destroy
			flash[:success] = "Mangá foi removido dos favoritos!"
		else
			flash[:danger] = "Mangá não pertence aos favoritos."
		end
		redirect_to ver_manga_path(params[:manga_id])
	end

	def buscar
		if params[:busca].present?
			palavras = params[:busca].split(' ')
			palavras.each do |palavra|
				@resultados = Manga.where('titulo like ?',"%#{palavra}%") if @resultados.nil?
				@resultados = @resultados.or(Manga.where('titulo like ?',"%#{palavra}%")) if @resultados.present?
			end
		end
	end
	
	def ver_manga
		@manga = Manga.find(params[:id])
		@capitulos = Capitulo.where(manga_id: @manga.id)
		@favorito = Favorito.where(manga_id: @manga.id, usuario_id: current_usuario.id)
		@autorizado = true if @manga.usuario_id == current_usuario.id
	end

	def ver_capitulo
		@capitulo = Capitulo.find(params[:id])
		@autorizado = true if @capitulo.manga.usuario_id == current_usuario.id
	end
	
	def ler_manga
	end

	def novo_manga
	end
	
	def novo_capitulo
		@manga = Manga.where(id: params[:manga_id],usuario_id: current_usuario.id).first

		if @manga.nil?
			flash[:danger] = "Usuário não possui permissão para criar novo capítulo neste mangá."
			redirect_to ver_manga_path(params[:manga_id])
		end

	end
	
	def editar_manga
		@manga = Manga.where(id: params[:id], usuario_id: current_usuario.id).first

		if @manga.present?
			@capitulos = Capitulo.where(manga_id: @manga.id)
		else
			flash[:danger] = 'Usuário não possui permissao para editar mangá.'
			redirect_to ver_manga_path(params[:id])
		end	

	end
	
	def editar_capitulo
		@capitulo = Capitulo.find(params[:id])

		if @capitulo.manga.usuario_id != current_usuario.id
			flash[:danger] = 'Usuário não possui permissao para editar capítulo.'
			redirect_to ver_manga_path(@capitulo.manga.id)
		end

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
		
		if capitulo.manga.usuario_id == current_usuario.id and capitulo.save
			flash[:success] = 'Capitulo criado com sucesso'

			if params[:paginas].present?
				params[:paginas].each_with_index do |pagina|
					Pagina.create({
						capitulo_id: capitulo.id,
						sequencia: sequencia_pagina(params,pagina.original_filename),
						arquivo: pagina.tempfile.read
					})
				end
			end
			redirect_to ver_manga_path(params[:manga_id])
		else
			flash[:danger] = 'Erro na criação do capítulo'
			redirect_to novo_capitulo_path(params[:manga_id])
		end
	end
	
	def atualizar_manga
		manga = Manga.where(id: params[:manga_id],usuario_id: current_usuario.id).first

		if manga.present?
		
			manga.titulo = params[:titulo]
			manga.descricao = params[:descricao]
			manga.finalizado = params[:finalizado]

			if params[:capa].present?
				if manga.capa.present?
					capa = manga.capa
					capa.arquivo = params[:capa].tempfile.read
					capa.save
				else
					Capa.create(manga_id: manga.id, arquivo: params[:capa].tempfile.read)
				end
			end

			if manga.save
				flash[:success] = 'Mangá foi atualizado com sucesso!'
				redirect_to ver_manga_path(manga.id)
			else
				flash[:danger] = 'Erro na atualização do mangá.'
				redirect_to editar_manga_path(manga.id)
			end

		else
			flash[:danger] = 'Usuário não possui permissão para editar mangá.'
			redirect_to editar_manga_path(params[:manga_id])
		end
	end
	
	def atualizar_capitulo
		capitulo = Capitulo.find(params[:capitulo_id])

		if capitulo.manga.usuario_id == current_usuario.id
		
			capitulo.titulo = params[:titulo]
			remove_paginas_inexistentes(params)
			atualiza_paginas_existentes(params)

			if params[:paginas].present?
				insere_novas_paginas(params)
			end

			if capitulo.save
				flash[:success] = "Capítulo atualizado com sucesso!"
				redirect_to ver_capitulo_path(capitulo.id)
			else
				flash[:danger] = "Erro na atualização do capítulo."
				redirect_to editar_capitulo_path(capitulo.id)
			end

		else
			flash[:danger] = "Usuário não possui permissão para editar capítulo."
			redirect_to editar_capitulo_path(capitulo.id)
		end
	end
	
	def excluir_capitulo
		capitulo = Capitulo.find(params[:capitulo_id])
		manga = Manga.where(id: capitulo.manga_id, usuario_id: current_usuario.id)
		if manga.present?
			capitulo.destroy
			flash[:success] = "Capítulo excluído com sucesso!"
			redirect_to ver_manga_path(capitulo.manga_id)
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
			redirect_to meus_mangas_path
		else
			flash[:danger] = "Não foi possível excluir mangá."
			redirect_to ver_manga_path(params[:manga_id])
		end
	end
	
	private

		def cria_hash_sequencia(params)
			params[:sequencia_paginas].map{|sequencia| JSON.parse(sequencia) }
		end

		def sequencia_pagina(params,filename)
			sequencia = cria_hash_sequencia(params)
			sequencia_item = sequencia.filter{|sequencia| sequencia["nome"] == filename}.first
			sequencia_item["sequencia"] if sequencia_item.present?
		end

		def pagina_por_nome(params,nome)
			params[:paginas].filter{|pagina| pagina.original_filename == nome}.first
		end

		def atualiza_paginas_existentes(params)
			sequencia = cria_hash_sequencia(params)
			sequencia.each do |sequencia|
				Pagina.where(nome: sequencia["nome"]).update(sequencia: sequencia["sequencia"])
			end
		end

		def remove_paginas_inexistentes(params)
			sequencia = cria_hash_sequencia(params)
			nomes = sequencia.pluck("nome")
			capitulo_id = params[:capitulo_id]
			Pagina.where(capitulo_id: capitulo_id).each do |pagina|
				pagina.destroy if nomes.exclude?(pagina.nome)
			end
		end

		def insere_novas_paginas(params)
			sequencia = cria_hash_sequencia(params)
			sequencia.each do |sequencia|
				capitulo_id = params[:capitulo_id]
				pagina = pagina_por_nome(params,sequencia["nome"])
				Pagina.create(capitulo_id: capitulo_id, sequencia: sequencia["sequencia"], arquivo: pagina.tempfile.read) if Pagina.where(capitulo_id: capitulo_id, sequencia: sequencia["sequencia"]).empty?
			end
		end

end