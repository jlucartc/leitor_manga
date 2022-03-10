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
			pagina = Tempfile.new([self.nome,'.jpeg'],caminho_diretorio_pagina,binmode: true)
			pagina.write(self.arquivo)
			pagina.path.gsub(/^.+\/public/,'')
		else
			array_arquivos_paginas.each do |arquivo|
				File.delete(caminho_arquivo_pagina(arquivo))
			end
			path
		end
	end

	private

		def array_arquivos_paginas
			Dir.glob("#{self.nome}*\.jpeg",base: "#{caminho_diretorio_pagina}")
		end

		def caminho_diretorio_pagina
			"#{Rails.public_path.to_s}/tmp/paginas"
		end

		def caminho_arquivo_pagina(arquivo)
			"#{caminho_diretorio_pagina}/#{arquivo}"
		end

end
