class Pagina < ApplicationRecord
	belongs_to :capitulo
	validates :capitulo_id, :sequencia, :arquivo, presence: true
	validates :nome, uniqueness: true
	before_create :escolhe_nome
	after_destroy :ajusta_sequencia

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

	private

		def retorna_novo_path
			capa = Tempfile.new([self.nome,'.jpeg'],caminho_diretorio_pagina,binmode: true)
			capa.write(self.arquivo)
			capa.path.gsub(/^.+\/public/,'')
		end

		def arquivo_existe?
			retorna_path_arquivo.present?
		end

		def retorna_path_arquivo
			array_arquivos_paginas.filter{|arquivo| arquivo.match(Regexp.new("^#{self.nome}.*\.jpeg$")) }.first
		end

		def array_arquivos_paginas
			Dir.glob("#{self.nome}*\.jpeg",base: "#{caminho_diretorio_pagina}")
		end

		def caminho_diretorio_pagina
			"#{Rails.public_path.to_s}/tmp/paginas"
		end
end
