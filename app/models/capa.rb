class Capa < ApplicationRecord
	belongs_to :manga
	validates :manga_id, :arquivo, presence: true
	validates :nome, uniqueness: true
	before_create :escolhe_nome

	def escolhe_nome
		nome = "#{SecureRandom.hex(20)}_"
		if Capa.where(nome: nome).present?
			escolhe_nome
		else
			self.nome = nome
		end 
	end

	def path
		if array_arquivos_capas.empty?
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
			capa = Tempfile.new([self.nome,'.jpeg'],caminho_diretorio_capa,binmode: true)
			capa.write(self.arquivo)
			capa.path.gsub(/^.+\/public/,'')
		end

		def arquivo_existe?
			retorna_path_arquivo.present?
		end

		def retorna_path_arquivo
			array_arquivos_capas.filter{|arquivo| arquivo.match(Regexp.new("^#{self.nome}.*\.jpeg$")) }.first
		end

		def array_arquivos_capas
			Dir.glob("#{self.nome}*\.jpeg",base: caminho_diretorio_capa)
		end

		def caminho_diretorio_capa
			"#{Rails.public_path.to_s}/tmp/capas"
		end
end
