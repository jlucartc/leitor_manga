class Capa < ApplicationRecord
	belongs_to :manga
	validates :manga_id, :arquivo, presence: true
	validates :nome, uniqueness: true
	before_create :escolhe_nome
	after_update :atualiza_arquivo

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

	def atualiza_arquivo
		if array_arquivos_capas.empty?
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
			if File.exist?("#{caminho_diretorio_capa}/#{filename}")
				retorna_novo_path
			else
				capa = File.open("#{caminho_diretorio_capa}/#{filename}",'wb')
				capa.write(self.arquivo)
				capa.close
				capa.path.gsub(/^.+\/public/,'')
			end
		end

		def exclui_arquivo
			full_path = "#{caminho_diretorio_capa}/#{array_arquivos_capas.filter{|arquivo| arquivo.match(Regexp.new("^#{self.nome}.*\.jpeg$")) }.first}"
			File.delete(full_path) if File.exist?(full_path)
		end

		def arquivo_existe?
			retorna_path_arquivo.present?
		end

		def retorna_path_arquivo
			full_path = "#{caminho_diretorio_capa}/#{array_arquivos_capas.filter{|arquivo| arquivo.match(Regexp.new("^#{self.nome}.*\.jpeg$")) }.first}"
			full_path.gsub(/^.+\/public/,'')
		end

		def array_arquivos_capas
			Dir.glob("#{self.nome}*\.jpeg",base: caminho_diretorio_capa)
		end

		def caminho_diretorio_capa
			"#{Rails.public_path.to_s}/tmp/capas"
		end
end
