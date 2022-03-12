class Pagina < ApplicationRecord
	belongs_to :capitulo
	validates :capitulo_id, :sequencia, :arquivo, presence: true
	validates :nome, uniqueness: true
	before_create :escolhe_nome
	after_destroy :ajusta_sequencia
	after_update :atualiza_arquivo

	def escolhe_nome
		nome = "#{SecureRandom.hex(20)}_"
		if Pagina.where(nome: nome).present?
			escolhe_nome
		else
			self.nome = nome
		end 
	end

	def ajusta_sequencia
		if Pagina.where("capitulo_id = ? and sequencia = ?",self.capitulo_id,self.sequencia).empty?
			paginas = Pagina.where("capitulo_id = ? and sequencia > ?",self.capitulo_id,self.sequencia)
			paginas.each do |pagina|
				pagina.update(sequencia: pagina.sequencia-1)
			end
		end
	end

	def sequencia_data
		{nome: self.nome,sequencia: self.sequencia}.to_json
	end

	def path
		if array_arquivos_paginas.empty?
			retorna_novo_path
		else
			if arquivo_existe?
				retorna_path_arquivo
			else
				retorna_novo_path
			end
		end
	end

	def atualiza_arquivo
		if array_arquivos_paginas.empty?
			retorna_novo_path
		else
			if arquivo_existe?
				exclui_arquivo
				retorna_novo_path
			else
				retorna_novo_path
			end
		end
	end

	private

		def retorna_novo_path
			filename = "#{self.nome}#{SecureRandom.hex(20)}.jpeg"
			if File.exist?("#{caminho_diretorio_pagina}/#{filename}")
				retorna_novo_path
			else
				pagina = File.open("#{caminho_diretorio_pagina}/#{filename}",'wb')
				pagina.write(self.arquivo)
				pagina.close
				pagina.path.gsub(/^.+\/public/,'')
			end
		end

		def exclui_arquivo
			full_path = "#{caminho_diretorio_pagina}/#{array_arquivos_paginas.filter{|arquivo| arquivo.match(Regexp.new("^#{self.nome}.*\.jpeg$")) }.first}"
			File.delete(full_path) if File.exist?(full_path)
		end

		def arquivo_existe?
			retorna_path_arquivo.present?
		end

		def retorna_path_arquivo
			full_path = "#{caminho_diretorio_pagina}/#{array_arquivos_paginas.filter{|arquivo| arquivo.match(Regexp.new("^#{self.nome}.*\.jpeg$")) }.first}"
			full_path.gsub(/^.+\/public/,'')
		end

		def array_arquivos_paginas
			Dir.glob("#{self.nome}*\.jpeg",base: "#{caminho_diretorio_pagina}")
		end

		def caminho_diretorio_pagina
			"#{Rails.public_path.to_s}/tmp/paginas"
		end
end
